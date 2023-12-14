(const *json-schema-basic-types* '("string" "object" "number" "array" "boolean"))

(defclass  (json-schema-title lml-component) (init-attrs)
  (super init-attrs)
  (set-state (merge {:is_editing nil} init-attrs))
  this)

(defmethod  json-schema-title render ()
  (!= props.schema.title
    ($$ (? state.is_editing
           `(input :grab-focus  1
                   :on-blur     ,[set-state {:is_editing nil}]
                   :on-change   ,[state.parent.update :title (_.target.value)]
                   :value       ,(| ! ""))
           `(span :on-click ,[set-state {:is_editing t}]
              ,(+ "(" (| ! "no title") ")"))))))

(finalize-class json-schema-title)
(declare-lml-component json-schema-title)

(fn json-schema-type (attrs)
  (!= attrs.schema
    ($$ `(div ,!.type (json-schema-title :schema ,!)))))

(declare-lml-component json-schema-type)


(defclass (json-schema-object lml-component) (init-attrs)
  (super init-attrs)
  (replace-state init-attrs)
  this)

(defmethod json-schema-object update (key val)
  (!= state
    (let k !.key    ; TODO: Add key expressions for JSON in tré. (pixel)
      (replace-state (merge {k val} state))
      (when !.key
        (!.parent.update !.key !.schema)))))

(defmethod json-schema-object add (e)
  (!= ($? "<.json-add" e.target)
    (= (ref state.schema.properties ($? "input" !).value) ($? "select" !).value)
    (replace-state state)))

(defmethod json-schema-object render ()
  (!= state.schema
    ($$ `(table
           (tr (th :class "json-schema-typename" :colspan 2 "object " (json-schema-title :schema ,!)))
           ,@(maphash #'((k v)
                          `(tr
                             (td ,(+ k ":"))
                             (td (json-schema :schema ,v :key ,k :parent ,this))))
                      !.properties)
           (tr :class "json-add"
             (td (input :type "text"))
             (td
               (select ,@(@ [`(option :value ,_ ,_)]
                            *json-schema-basic-types*))
               (button "+" :on-click ,[add _])))))))

(finalize-class json-schema-object)
(declare-lml-component json-schema-object)


(fn expand-type (props)
  (? (string? props)
     {:type props}
     props))

(fn json-schema (attrs)
  (!= (expand-type attrs.schema)
    ($$ `(,(? (string== "object" !.type)
              'json-schema-object
              'json-schema-type)
          :schema ,! :key ,attrs.key))))

(declare-lml-component json-schema)


(var *schema* {
    :type      "object"
    :title     "Test"
    :properties {
        :name  "string"
        :surname  {
            :type  "string"
        }
        :age       "number"
        :is_member "boolean"
        :guests    "array"
    }
})

(document.body.add ($$ `(json-schema :schema ,*schema*)))

(!= (new *mutation-observer
         #'((l o)
             (($* "[grabfocus]").map [(_.focus)])))
  (!.observe document.body {"childList" t "subtree" t}))
