import static spark.Spark.*;

public class App {
    public static void main(String[] args) {
        port(4567);
        secure("/certs/keystore.p12", "spark-jetty-mkcert", null, null);
        get("/", (req, res) -> "Hello HTTPS Spark + Jetty!");
    }
}