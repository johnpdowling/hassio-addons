#!/usr/local/bin/python
#
# 8/2021 - https://github.com/bdwilson/waterguru-api
#
# Please do not abuse the WaterGuru API - this should not be run more than 
# once or twice a day. It is not intended to be run more often as it does 
# not properly implement a token refresh option (hint hint, please add)
#
# sudo apt-get install python3 python3-pip 
# sudo pip3 install flask requests_aws4auth boto3 warrant.aws_srp warrant
#
# Set your email, password and port to run this service on.
#
# Usage: /api/wg returns dashboard info for all WaterGuru devices. 
#
# There is little error checking and no security here.
# 
from flask import Flask, render_template, flash, request, jsonify, Response
import os
import logging
from warrant import Cognito
import boto3
from warrant.aws_srp import AWSSRP
import requests
import logging
from requests_aws4auth import AWS4Auth

# App config.
DEBUG = False
app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = '32624076087108375603827608353'

config = {
    "port": "WG_PORT", # port for your service to run on
	"user": "WG_USER",
	"pass": "WG_PASS"
}

def doWg():
	region_name = "us-west-2"
	pool_id = "us-west-2_icsnuWQWw"
	identity_pool_id = "us-west-2:691e3287-5776-40f2-a502-759de65a8f1c"
	client_id = "7pk5du7fitqb419oabb3r92lni"
	idp_pool = "cognito-idp.us-west-2.amazonaws.com/" + pool_id

	boto3.setup_default_session(region_name = region_name)
	client = boto3.client('cognito-idp', region_name=region_name)
	# REFRESH_TOKEN_AUTH flow doesn't exist yet in warrant lib https://github.com/capless/warrant/issues/33
    # would love it if someone could figure out proper refresh. 
	aws = AWSSRP(username=config['user'], password=config['pass'], pool_id=pool_id, client_id=client_id, client=client)
	tokens = aws.authenticate_user()

	id_token = tokens['AuthenticationResult']['IdToken']
	refresh_token = tokens['AuthenticationResult']['RefreshToken']
	access_token = tokens['AuthenticationResult']['AccessToken']
	token_type = tokens['AuthenticationResult']['TokenType']

	u=Cognito(pool_id,client_id,id_token=id_token,refresh_token=refresh_token,access_token=access_token)
	user = u.get_user()
	userId = user._metadata['username']

	boto3.setup_default_session(region_name = region_name)
	identity_client = boto3.client('cognito-identity', region_name=region_name)
	identity_response = identity_client.get_id(IdentityPoolId=identity_pool_id)
	identity_id = identity_response['IdentityId']

	credentials_response = identity_client.get_credentials_for_identity(IdentityId=identity_id,Logins={idp_pool:id_token})
	credentials = credentials_response['Credentials']
	access_key_id = credentials['AccessKeyId']
	secret_key = credentials['SecretKey']
	service = 'lambda'
	session_token = credentials['SessionToken']
	expiration = credentials['Expiration']

	method = 'POST'
	headers = {'User-Agent': 'aws-sdk-iOS/2.24.3 iOS/14.7.1 en_US invoker', 'Content-Type': 'application/x-amz-json-1.0'}
	body = {"userId":userId, "clientType":"WEB_APP", "clientVersion":"0.2.3"}
	service = 'lambda'
	url = 'https://lambda.us-west-2.amazonaws.com/2015-03-31/functions/prod-getDashboardView/invocations'
	region = 'us-west-2'

	auth = AWS4Auth(access_key_id, secret_key, region, service, session_token=session_token)
	response = requests.request(method, url, auth=auth, json=body, headers=headers)
	return(response.text)

@app.route("/", methods=['GET'])
def info():
	return("Try: /api/wg")

@app.route("/api/wg", methods=['GET'])
def api():
	val = doWg()
	if val:
		return Response(val, mimetype='application/json')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=config['port'], debug=False)

