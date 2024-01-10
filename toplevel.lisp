(const *json-schema-basic-types*
    '("boolean"
      "number"
      "string"
      "array"
      "object"))


(!= (new *mutation-observer
         #'((l o)
             (($* "[grabfocus]").map [_.focus])))
  (!.observe document.body {:child-list t :subtree t}))

(fn expand-type (props)
  (? (string? props)
     {:type props}
     props))


(defclass (json-schema-title lml-component) (attrs)
  (super attrs)
  (set-state {:is_editing nil})
  this)

(defmethod json-schema-title render ()
  (!= props.schema.title
    (? state.is_editing
       `(div
          (input
            :grab-focus  t
            :value
               ,(| ! "")
            :on-blur
              ,[set-state {:is_editing nil}]
            :on-change
              ,[props.parent.update "title" _.target.value])
          (button
            :on-click
              [$ (_.target).remove]
            "X"))
       `(span
          :on-click ,[set-state {:is_editing t}]
          ,(+ "(" (| ! "no title") ")")))))

(finalize-class json-schema-title)
(declare-lml-component json-schema-title)


(fn json-schema-type (attrs)
  (!= attrs.schema
    `(div
       ,!.type
       " "
       (json-schema-title
         :schema ,!
         :parent ,attrs.parent))))

(declare-lml-component json-schema-type)


(defclass (json-schema-object lml-component) (attrs)
  (super attrs)
  this)

(defmethod json-schema-object update (key val)
  (set-state props)
  (= (ref state.schema.properties key) val)
  (state.parent.update key state.schema))

(defmethod json-schema-object add (e)
  (!= ($? "<.json-add" e.target)
    (set-state props)
    (= (ref state.schema.properties ($? "input" !).value)
       ($? "select" !).value)))

(defmethod json-schema-object render ()
  (!= props.schema
    `(table
       (tr
         (th :class "json-schema-typename"
           "object "
           (json-schema-title
             :schema ,!
             :parent ,this)))
       ,@(maphash #'((k v)
                      `(tr
                         (td ,k)
                         (td (json-schema
                               :schema ,v
                               :key    ,k
                               :parent ,this))))
                  !.properties)
       (tr :class "json-add"
         (td (input :type "text"))
         (td
           (select
             ,@(@ [`(option
                      :value ,_
                      ,_)]
                  *json-schema-basic-types*))
           (button
             :on-click ,[add _]
             "+"))))))

(finalize-class json-schema-object)
(declare-lml-component json-schema-object)


(fn json-schema (attrs)
  (!= (expand-type attrs.schema)
    `(,(? (eql "object" !.type)
          'json-schema-object
          'json-schema-type)
      :schema  ,!
      :key     ,attrs.key
      :parent  ,attrs.parent)))

(declare-lml-component json-schema)


;;; Container to catch and write back the the whole modified JSON on updates.
(defclass (json-schema-container lml-component) (attrs)
  (super attrs)
  this)

(defmethod json-schema-container update (dummy-key value)
  (set-state (new))
  (props.writer value))

(defmethod json-schema-container render ()
  `(json-schema
     :schema  ,props.schema
     :parent  ,this
     :key     nil))

(finalize-class json-schema-container)
(declare-lml-component json-schema-container)

(var *schemas* (new))

(fn add-schema (name schema)
  (= (ref *schemas* name) schema))

(add-schema "option" {
   :type   "string"
   :one-of '("no" "optional" "required")
})

(add-schema "directory" {
  :type  "object"
  :title "Directory"
  :properties {
    :name         "string"
    :description  "string"
    :items {
      :type "array"
      :items {
        :one-of (list {:$ref "directory"}
                      {:$ref "vicitem"}
        )
      }
    }
  }
  :required '("name" "description")
})

(fn +@ (fun x)
  (apply #'+ (@ fun x)))

(fn propmap (fun x)
  (apply #'make-json-object (+@ fun (group 2 x))))

(fn reftype (r x)
  (list x. {:$ref r :title .x.}))

(fn options (&rest x)
  (propmap [reftype "option" _] x))

(add-schema "vicitem" {
  :type  "object"
  :title "Item"
  :properties {
    :title {
      :type  "string"
      :title "Title"
    }
    :date {
      :type  "string"
      :title "Release date"
    }
    :descrption "string"
    :author     "string"
    :input {
      :type "object"
      :properties
        (options :keyboard "Keyboard"
                 :joystick "Joystick"
                 :paddles  "Paddles"
                 :lightpen "Lightpen")
    }
    :memory {
      :type  "object"
      :title "Memory requirements"
      :properties
        (options :ram123 "+3K RAM123 ($0400-$0fff)"
                 :blk1   "+8K BLK1 ($2000-3fff)"
                 :blk2   "+16K BLK2 ($4000-5fff)"
                 :blk3   "+24K BLK3 ($6000-7fff)"
                 :blk5   "+32K BLK5 ($a000-bfff)"
                 :io23   "+2K IO23 ($9800-9fff)")
    }
    :expansions {
      :type   "object"
      :title  "Memory expansions"
      :properties
        (options :ultimem  "UltiMem"
                 :fe3      "Final Expansion 3")
    }
    :file               "string"
    :confirmed-to-run   "boolean"
  }
})

(var *data* {
  :title  "Index"
  :items  nil
})

(document.body.add
  ($$
    `(autoform-object
       :schema  ,(ref *schemas* "directory")
       :data    ,*data*
       :fields  ("name" "description"))))

;(document.body.add ($$ `(json-schema-container
;                            :schema ,(ref *schema* "directory")
;                            :writer ,[dump _ "Updated JSON"])))
