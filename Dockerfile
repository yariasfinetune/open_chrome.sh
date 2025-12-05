FROM python:3.11-slim

# Install mitmproxy and any other necessary tools
RUN pip install --no-cache-dir mitmproxy

# Copy the proxy script and any dependencies into the image
COPY start_proxy.sh /start_proxy.sh
COPY map_host.py /map_host.py

# Make sure the script is executable
RUN chmod +x /start_proxy.sh

EXPOSE 8089

CMD ["/start_proxy.sh"]