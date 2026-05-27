# Tiny static-site image for Coolify (or any Docker host).
# Coolify auto-detects this Dockerfile and exposes port 80.
FROM nginx:1.27-alpine

# Drop the default nginx welcome page and bring our own conf
RUN rm -rf /usr/share/nginx/html/* /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

# Health check (Coolify uses this)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ >/dev/null || exit 1
