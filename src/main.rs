use axum::{routing::get, Router};
use std::net::SocketAddr;
use tokio::net::TcpListener;

#[tokio::main]
async fn main() {
    // ルーターを作成
    let app = Router::new().route("/", get(|| async { "Hello, World!" }));

    // サーバーを起動（localhostの8000ポート）
    let listener = TcpListener::bind("127.0.0.1:8000").await.unwrap();
    println!("Listening on http://127.0.0.1:8000");

    axum::serve(listener, app).await.unwrap();
}
