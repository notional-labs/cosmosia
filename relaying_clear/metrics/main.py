import time
from prometheus_client import Gauge, start_http_server


def metrics_server():
    # Start up the server to expose the metrics.
    start_http_server(8000)

    # wallet_balance{account="migaloo1t53wkmgjp5vksed2hw4e3625kq0jyas06w9shm",chain="migaloo-1",denom="uwhale",service_name="unknown_service",otel_scope_name="hermes",otel_scope_version=""} 22086720
    g_wallet_balance = Gauge('wallet_balance', 'TYPE wallet_balance gauge', ["label1", "label2"])
    # g_wallet_balance1 = Gauge('wallet_balance1', 'TYPE wallet_balance gauge', ["label1", "label2"])

    while True:
        g_wallet_balance.labels(label1="value1", label2="value2").set(1.2)
        g_wallet_balance.labels(label1="value3", label2="value4").set(3.4)
        time.sleep(60)


if __name__ == '__main__':
    metrics_server()
