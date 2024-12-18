FROM python:3.13-slim

WORKDIR /docs

COPY pyproject.toml .
COPY uv.lock .

RUN pip install --no-cache-dir uv && \
    uv pip install --system .

COPY mkdocs.yml .
COPY docs/ docs/

RUN mkdocs build

FROM nginx:alpine

COPY --from=0 /docs/site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 