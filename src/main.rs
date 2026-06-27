use std::io::{Read, Write};
use std::net::TcpListener;
use std::thread;

fn handle_connection(mut stream: std::net::TcpStream) {
    let mut buf = [0u8; 1024];
    if let Err(e) = stream.read(&mut buf) {
        eprintln!("Failed to read from connection: {}", e);
        return;
    }
    let response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nInfodemic-AI-Core is running.\n";
    if let Err(e) = stream.write_all(response.as_bytes()) {
        eprintln!("Failed to write response: {}", e);
    }
}

fn main() {
    let addr = "0.0.0.0:8080";
    let listener = TcpListener::bind(addr).expect("Failed to bind address");
    println!("Infodemic-AI-Core listening on {}", addr);

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                thread::spawn(|| handle_connection(stream));
            }
            Err(e) => eprintln!("Connection error: {}", e),
        }
    }
}
