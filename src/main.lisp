(fn json-schema-string (props)
  ($$ `(div "string")))

(declare-lml-component json-schema-string)


(fn json-schema-object (props)
  (!= props.schema
    ($$ `(div
           (h1 ,!.title)
           ,@(maphash #'((k v)
                          `(div ,(+ k ":")
                                (json-schema :schema ,v)))
                      !.properties)))))

(declare-lml-component json-schema-object)


(fn json-schema-type-props (props)
  (? (string? props)
     {"type" props}
     props))

(fn json-schema (props)
  (!= (json-schema-type-props props.schema)
    (case !.type
      "object"    (json-schema-object props)
      "string"    (json-schema-string props)
      (error "Unknown type ~A" !.type))))

(declare-lml-component json-schema)


(var *schema* {
    "type"      "object"
    "title"     "Test"
    "properties" {
        "name"  "string"
        "surname"  {
            "type"  "string"
        }
    }
})

(document.body.add ($$ `(json-schema :schema ,*schema*)))
