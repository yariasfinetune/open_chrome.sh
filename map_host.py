# map_host.py
from mitmproxy import http

UAT_TARGET_HOST = "apclassroom-uat.collegeboard.org"
TESTING_TARGET_HOST = "apclassroom-testing.collegeboard.org"
PROD_TARGET_HOST = "apclassroom.collegeboard.org"
TARGET_IP = "54.145.35.252"

hosts = [TESTING_TARGET_HOST, UAT_TARGET_HOST, PROD_TARGET_HOST]

def request(flow: http.HTTPFlow) -> None:
    # Debug: print the requested host
    print(f"Request to: {flow.request.pretty_host}")
    
    # match the requested hostname
    if flow.request.pretty_host in hosts:
        print(f"Redirecting {flow.request.pretty_host} to {TARGET_IP}")
        # keep the Host header as the original hostname so upstream virtual host works
        flow.request.headers["Host"] = flow.request.pretty_host
        TARGET_HOST = flow.request.pretty_host
        # set the connection target to the IP (keep scheme to choose port)
        if flow.request.scheme == "https":
            flow.request.host = TARGET_IP
            flow.request.port = 443
        else:
            flow.request.host = TARGET_IP
            flow.request.port = 80

