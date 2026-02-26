from bottle import Bottle, run, response

app = Bottle()

@app.route("/")
def index():
    response.content_type = "text/plain"
    return "Hello HTTPS Bottle via Caddy!"

if __name__ == "__main__":
    run(app, host="0.0.0.0", port=8080)