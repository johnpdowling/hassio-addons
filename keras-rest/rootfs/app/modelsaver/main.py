"""
Keras model to TensorRT graph script that downloads keras models and coverts them to tensor graphs
Adapted from https://www.dlology.com/blog/how-to-run-keras-model-on-jetson-nano/
"""
import base64
import json
import os
import sys
import time
import tensorflow as tf
import tensorflow.contrib.tensorrt as trt

from tensorflow.python.framework import graph_io
from tensorflow.keras.models import load_model
from keras.applications import ResNet50

model_folder = '/config/keras-rest/models'
model_name = os.environ['MODEL_NAME']

def freeze_graph(graph, session, output, save_pb_dir='/config/keras-rest/models', save_pb_name='frozen_model.pb', save_pb_as_text=False):
    with graph.as_default():
        graphdef_inf = tf.graph_util.remove_training_nodes(graph.as_graph_def())
        graphdef_frozen = tf.graph_util.convert_variables_to_constants(session, graphdef_inf, output)
        graph_io.write_graph(graphdef_frozen, save_pb_dir, save_pb_name, as_text=save_pb_as_text)
        return graphdef_frozen

def save_model():
    #get the model, save the model
    model = ResNet50(weights=name)
    model.save(model_folder + '/' + model_name + '.h5')
    # Clear any previous session.
    tf.keras.backend.clear_session()
    
    # This line must be executed before loading Keras model.
    tf.keras.backend.set_learning_phase(0) 
    model = load_model(model_folder + '/' + model_name + '.h5')
    session = tf.keras.backend.get_session()
    input_names = [t.op.name for t in model.inputs]
    output_names = [t.op.name for t in model.outputs]
    # freeze the model to a graph
    frozen_graph = freeze_graph(session.graph, session, [out.op.name for out in model.outputs], save_pb_dir=model_folder)
    trt_graph = trt.create_inference_graph(
        input_graph_def=frozen_graph,
        outputs=output_names,
        max_batch_size=1,
        max_workspace_size_bytes=1 << 25,
        precision_mode='FP16',
        minimum_segment_size=50
    )
    graph_io.write_graph(trt_graph, model_folder + '/',
                         model_name + '.pb', as_text=False)
                     
if __name__ == "__main__":
    os.makedirs(model_folder, exist_ok=True)
    save_model()
