from setuptools import setup, find_packages

setup(
  name='libvirt-nix-setup-script',
  packages = find_packages(),
  scripts=[ "app/main.py" ],
  version='1.0',
)