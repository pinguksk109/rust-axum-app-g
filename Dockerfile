# Rustのslim-bullseyeイメージを使用
FROM rust:slim-bullseye AS builder

# 作業ディレクトリを作成
WORKDIR /app

# 依存関係をコピー（キャッシュを活用）
COPY Cargo.toml Cargo.lock ./
RUN cargo fetch

# ソースコードをコピー
COPY . .

# リリースビルド
RUN cargo build --release

# 実行環境のベースイメージ
FROM debian:bullseye-slim

# 必要なライブラリをインストール（SSL対応のため ca-certificates）
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# ビルド済みバイナリをコピー
COPY --from=builder /app/target/release/rust-axum-app /app/rust-axum-app

# 実行
CMD ["/app/rust-axum-app"]
