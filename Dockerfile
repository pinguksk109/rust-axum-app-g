# Rustの公式イメージを使う
FROM rust:1.73 as builder

# 作業ディレクトリを設定
WORKDIR /app

# Cargo.toml と Cargo.lock をコピー（依存関係をキャッシュするため）
COPY Cargo.toml Cargo.lock ./

# 依存関係を先にダウンロード（キャッシュを活用）
RUN cargo fetch

# ソースコードをコピー
COPY src ./src

# リリースビルド（最適化されたバイナリを作成）
RUN cargo build --release

# 実行環境として軽量なAlpine Linuxを使用
FROM debian:bullseye-slim

# 必要なライブラリをインストール
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# Rustのバイナリをコピー
COPY --from=builder /app/target/release/axum-app .

# ポートを公開（Dockerコンテナ内部のポートを指定）
EXPOSE 8000

# アプリを実行
CMD ["./axum-app"]
