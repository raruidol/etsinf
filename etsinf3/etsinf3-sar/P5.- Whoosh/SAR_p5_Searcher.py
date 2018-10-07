#!/usr/bin/env python

from whoosh.index import open_dir
from whoosh.qparser import QueryParser

ix = open_dir("index_dir")
with ix.searcher() as searcher:
    text = input("Dime:")
    while len(text) > 0:
        query = QueryParser("content", ix.schema).parse(text)
        results = searcher.search(query)
        for r in results:

            print (r)
#        print (dir(results))
#        print (results.docs)
        text = input("Dime más:")
