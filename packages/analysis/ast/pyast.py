#!/usr/bin/env python
from __future__ import print_function
import sys
import json
import subprocess

def hydrate(ast):
	if isinstance(ast, dict):
		if 'nodeType' in ast:
			nodeType = globals().get(ast['nodeType'], Node)
			return nodeType(**ast)
	return ast

class Node(object):
	_REGISTRY = dict()

	@classmethod
	def byId(cls, node_id):
		return cls._REGISTRY[node_id]

	def __init__(self, **kwa):
		self._REGISTRY[kwa['id']] = self
		if 'scope' in kwa:
			kwa['scope'] = self._REGISTRY[kwa['scope']]
		for field, value in kwa.items():
			if field[0] == '_':
				continue
			if isinstance(value, dict) and 'nodeType' in value:
				kwa[field] = hydrate(value)
			elif isinstance(value, list):
				kwa[field] = [hydrate(X) for X in value]
		self.__dict__.update(kwa)

def compile(filename):
	"""returns ast dict tree"""
	result = subprocess.check_output(['solc', '--ast-compact-json', filename])
	# Remove header/footer from solc output
	first_split = ' ======='
	result = result[result.index(first_split) + len(first_split) + 1:]
	#last_split = '======= '
	#result = result[:result.rindex(last_split) - 1]
	return json.loads(result)

def main(args):
	for filename in args:
		#print("Compiling", filename)
		ast = compile(filename)
		unit = hydrate(ast)
		print(unit.nodes[1].nodes[2].__dict__)


if __name__ == "__main__":
	sys.exit(main(sys.argv[1:]))
