"""
Model server script that polls Redis for images to classify

Adapted from https://www.pyimagesearch.com/2018/02/05/deep-learning-production-keras-redis-flask-apache/
"""
import base64
import json
import os
import sys
import time

from keras.applications import ResNet50
from keras.applications import imagenet_utils
import numpy as np
import redis

models_folder = "/config/keras-rest/models"

# Connect to Redis server
db = redis.StrictRedis(host=os.environ.get("REDIS_HOST"))

def load_graph(frozen_graph_filename):
    # We load the protobuf file from the disk and parse it to retrieve the 
    # unserialized graph_def
    with tf.gfile.GFile(frozen_graph_filename, "rb") as f:
        graph_def = tf.GraphDef()
        graph_def.ParseFromString(f.read())

    # Then, we can use again a convenient built-in function to import a graph_def into the 
    # current default Graph
    with tf.Graph().as_default() as graph:
        tf.import_graph_def(
            graph_def, 
            input_map=None, 
            return_elements=None, 
            name="prefix", 
            op_dict=None, 
            producer_op_list=None
        )

    input_name = graph.get_operations()[0].name+':0'
    output_name = graph.get_operations()[-1].name+':0'

    return graph, input_name, output_name

def model_predict(model_path, input_data):
    # load tf graph
    tf_model,tf_input,tf_output = load_graph(model_path)

    # Create tensors for model input and output
    x = tf_model.get_tensor_by_name(tf_input)
    y = tf_model.get_tensor_by_name(tf_output) 

    # Number of model outputs
    num_outputs = y.shape.as_list()[0]
    predictions = np.zeros((input_data.shape[0],num_outputs))
    for i in range(input_data.shape[0]):        
        with tf.Session(graph=tf_model) as sess:
            y_out = sess.run(y, feed_dict={x: input_data[i:i+1]})
            predictions[i] = y_out

    return predictions

def base64_decode_image(a, dtype, shape):
    # If this is Python 3, we need the extra step of encoding the
    # serialized NumPy string as a byte object
    if sys.version_info.major == 3:
        a = bytes(a, encoding="utf-8")

    # Convert the string to a NumPy array using the supplied data
    # type and target shape
    a = np.frombuffer(base64.decodestring(a), dtype=dtype)
    a = a.reshape(shape)

    # Return the decoded image
    return a


def classify_process():
    model_name = os.environ.get("MODEL_NAME")
    model_path = models_folder + '/' + model_name + '.pb'
    # Continually poll for new images to classify
    while True:
        # Pop off multiple images from Redis queue atomically
        with db.pipeline() as pipe:
            pipe.lrange(os.environ.get("IMAGE_QUEUE"), 0, int(os.environ.get("BATCH_SIZE")) - 1)
            pipe.ltrim(os.environ.get("IMAGE_QUEUE"), int(os.environ.get("BATCH_SIZE")), -1)
            queue, _ = pipe.execute()

        imageIDs = []
        batch = None
        for q in queue:
            # Deserialize the object and obtain the input image
            q = json.loads(q.decode("utf-8"))
            image = base64_decode_image(q["image"],
                                        os.environ.get("IMAGE_DTYPE"),
                                        (1, int(os.environ.get("IMAGE_HEIGHT")),
                                         int(os.environ.get("IMAGE_WIDTH")),
                                         int(os.environ.get("IMAGE_CHANS")))
                                        )

            # Check to see if the batch list is None
            if batch is None:
                batch = image

            # Otherwise, stack the data
            else:
                batch = np.vstack([batch, image])

            # Update the list of image IDs
            imageIDs.append(q["id"])

        # Check to see if we need to process the batch
        if len(imageIDs) > 0:
            # Classify the batch
            print("* Batch size: {}".format(batch.shape))
            # preds = model.predict(batch)
            preds = model_predict(model_path, batch)
            results = imagenet_utils.decode_predictions(preds)

            # Loop over the image IDs and their corresponding set of results from our model
            for (imageID, resultSet) in zip(imageIDs, results):
                # Initialize the list of output predictions
                output = []

                # Loop over the results and add them to the list of output predictions
                for (imagenetID, label, prob) in resultSet:
                    r = {"label": label, "probability": float(prob)}
                    output.append(r)

                # Store the output predictions in the database, using image ID as the key so we can fetch the results
                db.set(imageID, json.dumps(output))

        # Sleep for a small amount
        time.sleep(float(os.environ.get("SERVER_SLEEP")))

if __name__ == "__main__":
    classify_process()
