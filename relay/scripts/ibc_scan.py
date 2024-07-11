# This tool scan all info clients/connections/channels/ports between chainA and chainB

import requests
import time
from optparse import OptionParser
import sys


def scan_clients(url_api, chain_id):
    print("scan_clients... url_api={} chain_id={}".format(url_api, chain_id))
    pagination_key = ""

    while True:
        time.sleep(3)
        # print("pagination_key={}".format(pagination_key))
        url = "{}/ibc/core/client/v1/client_states?pagination.limit=100&pagination.key={}".format(url_api, pagination_key)
        print(url)
        rq = requests.get(url)
        rq_json = rq.json()
        pagination_key = rq_json["pagination"]["next_key"]
        client_states = rq_json["client_states"]
        if len(client_states) <= 0:
            break

        for cs in client_states:
            try:
                client_id = cs["client_id"]
                cs_chain_id = cs["client_state"]["chain_id"]
                print(cs_chain_id)
                if chain_id == cs_chain_id:
                    print("client_id={}, chain_id={}".format(client_id, cs_chain_id))
            except:
                print(cs)


if __name__ == '__main__':
    print("ibc_scan: scan all info clients/connections/channels/ports between chainA and chainB")
    parser = OptionParser()
    parser.add_option("", "--chain_id_a", dest="chain_id_a", help="chain_id", metavar="string")
    parser.add_option("", "--chain_id_b", dest="chain_id_b", help="chain_id", metavar="string")
    parser.add_option("", "--url_api_a", dest="url_api_a", help="api endpoint", metavar="string")
    parser.add_option("", "--url_api_b", dest="url_api_b", help="api endpoint", metavar="string")

    (options, args) = parser.parse_args()

    required = "chain_id_a chain_id_b url_api_a url_api_b".split()
    for r in required:
        if options.__dict__[r] is None:
            parser.error("parameter %s required" % r)
            parser.print_help()
            sys.exit(1)

    # if len(args) <= 0:
    #     parser.print_help()
    #     sys.exit(1)

    print("chain_id_a={}".format(options.chain_id_a))
    print("chain_id_b={}".format(options.chain_id_b))
    print("url_api_a={}".format(options.url_api_a))
    print("url_api_b={}".format(options.url_api_b))

    print("scan clients on {}".format(options.chain_id_a))
    scan_clients(options.url_api_a, options.chain_id_b)
