from http.server import BaseHTTPRequestHandler, HTTPServer
import getopt
import sys
from functools import partial
from ec2_metadata import ec2_metadata

# html code template for the default page served by this server
html = """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>{Title}</title>
        <link rel="icon" type="image/ico" href="https://a0.awsstatic.com/main/images/site/fav/favicon.ico" />
    </head>
    <body>
        <p>{Content}</p>
    </body>
</html>"""

# RequestHandler: Response depends on type of request made
class RequestHandler(BaseHTTPRequestHandler):
    def __init__(self, region, *args, **kwargs):
        self.region = region
        super().__init__(*args, **kwargs)

    def do_GET(self):
        print("path: ", self.path)

        # Default request URL without additional path info (main response page)
        if self.path == '/':

            message = "<h1>Hello from CloudAge</h1>"
            message += "<h1>What to watch next....</h1>"

            self.send_response(200)

            # Send headers
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            # Write html output
            self.wfile.write(
                bytes(
                    html.format(Title="AWS CloudAge", Content=message),
                    "utf-8"
                )
            )

        # Healthcheck request - will be used by the Elastic Load Balancer
        elif self.path == '/healthcheck':

            # Return a success status code
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            message = "<h1>Success</h1>"

            self.wfile.write(
                bytes(
                    html.format(Title="healthcheck", Content=message),
                    "utf-8"
                )
            )

        return


# Initialize server
def run(argv):
    try:
        opts, args = getopt.getopt(
            argv,
            "hs:p:r:",
            [
                "help",
                "server_ip=",
                "server_port=",
                "region="
            ]
        )
    except getopt.GetoptError:
        print('server.py -s <server_ip> -p <server_port> -r <AWS region>')
        sys.exit(2)
    print(opts)

    # Default value - will be over-written if supplied via args
    server_port = 80
    server_ip = '0.0.0.0'
    try:
        region = ec2_metadata.region
    except:
        region = 'us-east-1'

    # Get commandline arguments
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print('server.py -s <server_ip> -p <server_port> -r <AWS region>')
            sys.exit()
        elif opt in ("-s", "--server_ip"):
            server_ip = arg
        elif opt in ("-p", "--server_port"):
            server_port = int(arg)
        elif opt in ("-r", "--region"):
            region = arg

    # start server
    print('starting server...')
    server_address = (server_ip, server_port)

    handler = partial(RequestHandler, region)
    httpd = HTTPServer(server_address, handler)
    print('running server...')
    httpd.serve_forever()


if __name__ == "__main__":
    run(sys.argv[1:])