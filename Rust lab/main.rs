use std::fs;
use std::io::prelude::*;
use std::net::TcpListener;
use std::net::TcpStream;

fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();
    println!("Server running on http://127.0.0.1:7878");

    for stream in listener.incoming() {
        let stream = stream.unwrap();
        handle_connection(stream);
    }
}

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 1024];
    stream.read(&mut buffer).unwrap();

    let request = String::from_utf8_lossy(&buffer[..]);
    let request_line = request.lines().next().unwrap_or("");

    // Parse the request to get the path and query string
    let (status_line, filename) = if request_line.starts_with("GET / HTTP/") {
        ("HTTP/1.1 200 OK", "index.html")
    } else if request_line.starts_with("GET /page1.html") {
        ("HTTP/1.1 200 OK", "page1.html")
    } else if request_line.starts_with("GET /page2.html") {
        ("HTTP/1.1 200 OK", "page2.html")
    } else {
        ("HTTP/1.1 404 NOT FOUND", "404.html")
    };

    let contents = fs::read_to_string(filename).unwrap_or_else(|_| {
        String::from("<html><body><h1>404 - File Not Found</h1></body></html>")
    });

    let response = format!(
        "{}\r\nContent-Length: {}\r\n\r\n{}",
        status_line,
        contents.len(),
        contents
    );

    stream.write_all(response.as_bytes()).unwrap();
    stream.flush().unwrap();
}
