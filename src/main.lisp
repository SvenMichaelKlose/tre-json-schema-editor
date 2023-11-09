(fn json-schema-type (props)
  ($$ `(div "Hello world!")))

(declare-lml-component json-schema-type)

(document.body.add ($$ `(json-schema-type)))
