#!/usr/bin/env python

import os
from whoosh.index import create_in
from whoosh.fields import Schema, ID, TEXT

schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT)
idir = "index_dir"

if not os.path.exists(idir):
    os.mkdir(idir)
ix = create_in(idir, schema)

writer = ix.writer()
writer.add_document(title="First document", path="/a",
                        content="Este es el texto del primer documento_")
writer.add_document(title="Second document", path="/b",
                        content="Este es el TEXTO de nuestro segundo documento")



writer.commit()



