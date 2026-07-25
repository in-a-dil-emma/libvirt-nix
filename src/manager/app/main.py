import libvirt, sys, json, re
from virtlib import dict_merge, filter_strings
from contextlib import closing
from libvirt import virConnect

# libvirt doc
# https://libvirt.org/python.html

def manage_uri_domains(conn: virConnect, defs: list[dict]):
  try:
    conn.changeBegin()
    domains = conn.listAllDomains()
    for domain in domains:
      print(domain.XMLDesc())

    conn.changeCommit()
  except:
    conn.changeRollback()
  return

def manage_uri_networks(conn: virConnect, defs: list[dict]):
  return

def manage_uri_pools(conn: virConnect, defs: list[dict]):
  return

def manage_uri(uri: str, data: dict):
  dict_merge(data, data["unmanaged"])
  data.pop("unmanaged")
  print("Flattened data to", data)
  return
  with closing(libvirt.open(uri)) as conn:
    if data["domains"] != None:
      manage_uri_domains(conn, data["domains"])
    if data["networks"] != None:
      manage_uri_networks(conn, data["networks"])
    if data["pools"] != None:
      manage_uri_pools(conn, data["pools"])

def main(data: dict):
  print("Parsed data", data)
  for uri in data.keys():
    manage_uri(uri, data[uri])

if __name__ == '__main__':
  print("Got data", sys.argv[1])
  data = json.loads(sys.argv[1])
  main(data)