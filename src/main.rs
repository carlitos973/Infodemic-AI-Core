use std::io::{Read, Write};
use std::net::TcpListener;

fn main() {
    let addr = "0.0.0.0:8080";
    let listener = TcpListener::bind(addr).expect("Failed to bind address");
    println!("Infodemic-AI-Core listening on {}", addr);

    for stream in listener.incoming() {
        match stream {
            Ok(mut stream) => {
                let mut buf = [0u8; 1024];
                let _ = stream.read(&mut buf);
                let response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nInfodemic-AI-Core is running.\n";
                let _ = stream.write_all(response.as_bytes());
            }
            Err(e) => eprintln!("Connection error: {}", e),
        }
    }
}
