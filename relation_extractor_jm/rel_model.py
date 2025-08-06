from typing import List, Tuple, Callable

import spacy
from spacy.tokens import Doc, Span
from thinc.types import Floats2d, Ints1d, Ragged, cast
from thinc.api import Model, Linear, chain, Logistic


@spacy.registry.architectures("rel_model.v1")
def create_relation_model(
    create_instance_tensor: Model[List[Doc], Floats2d],
    classification_layer: Model[Floats2d, Floats2d],
) -> Model[List[Doc], Floats2d]:
    with Model.define_operators({">>": chain}):
        model = create_instance_tensor >> classification_layer
        model.attrs["get_instances"] = create_instance_tensor.attrs["get_instances"]
    return model


@spacy.registry.architectures("rel_classification_layer.v1")
def create_classification_layer(
    nO: int = None, nI: int = None
) -> Model[Floats2d, Floats2d]:
    with Model.define_operators({">>": chain}):
        return Linear(nO=nO, nI=nI) >> Logistic()


@spacy.registry.misc("rel_instance_generator.v1")
def create_instances(max_length: int) -> Callable[[Doc], List[Tuple[Span, Span]]]:
    def get_instances(doc: Doc) -> List[Tuple[Span, Span]]:
        instances = []
        for ent1 in doc.ents:
            for ent2 in doc.ents:
                if ent1 != ent2:
                    if max_length and abs(ent2.start - ent1.start) <= max_length:

###### JM ######

#                        instances.append((ent1, ent2))

                        if ent1.label_ == 'DEFENDANT' and ent2.label_ == 'OFF':

                            instances.append((ent1, ent2))

################

        return instances

    return get_instances


@spacy.registry.architectures("rel_instance_tensor.v1")
def create_tensors(
    tok2vec: Model[List[Doc], List[Floats2d]],
    pooling: Model[Ragged, Floats2d],
    get_instances: Callable[[Doc], List[Tuple[Span, Span]]],
) -> Model[List[Doc], Floats2d]:

    return Model(
        "instance_tensors",
        instance_forward,
        layers=[tok2vec, pooling],
        refs={"tok2vec": tok2vec, "pooling": pooling},
        attrs={"get_instances": get_instances},
        init=instance_init,
    )


def instance_forward(model: Model[List[Doc], Floats2d], docs: List[Doc], is_train: bool) -> Tuple[Floats2d, Callable]:
    pooling = model.get_ref("pooling")
    tok2vec = model.get_ref("tok2vec")
    get_instances = model.attrs["get_instances"]
    all_instances = [get_instances(doc) for doc in docs]
    tokvecs, bp_tokvecs = tok2vec(docs, is_train)

    ents = []
    lengths = []

###### JM ######

    for doc_nr, (instances, tokvec) in enumerate(zip(all_instances, tokvecs)):
        doc_token_indices = []
        doc_lengths = []

        for span1, span2 in instances:
            # Use only context tokens between the two spans
            if span1.end <= span2.start:
                context_indices = list(range(span1.end, span2.start))
            elif span2.end <= span1.start:
                context_indices = list(range(span2.end, span1.start))
            else:
                context_indices = []

            # If no context tokens, use a fallback (e.g. span2.start token)
            if not context_indices:
                context_indices = [span2.start]

            doc_token_indices.extend(context_indices)
            doc_lengths.append(len(context_indices))

        ents.append(tokvec[doc_token_indices])
        lengths.extend(doc_lengths)

################

    lengths = cast(Ints1d, model.ops.asarray(lengths, dtype="int32"))
    entities = Ragged(model.ops.flatten(ents), lengths)
    pooled, bp_pooled = pooling(entities, is_train)

###### JM ######

    # Reshape so that pairs of rows are concatenated
    #relations = model.ops.reshape2f(pooled, -1, pooled.shape[1] * 2)
    #relations = model.ops.reshape2f(pooled, -1, pooled.shape[1] * 3)
    relations = pooled

################

###### JM ######

    def backprop(d_relations: Floats2d) -> List[Doc]:

        #d_pooled = model.ops.reshape2f(d_relations, d_relations.shape[0] * 2, -1)
        #d_pooled = model.ops.reshape2f(d_relations, d_relations.shape[0] * 3, -1)
        #d_pooled = d_relations

        d_ents = bp_pooled(d_relations).data

        d_tokvecs = []

        ent_index = 0
        for doc_nr, (instances, tokvec) in enumerate(zip(all_instances, tokvecs)):
            shape = tokvec.shape
            d_tokvec = model.ops.alloc2f(*shape)
            count_occ = model.ops.alloc2f(*shape)

            for span1, span2 in instances:
                # Same logic as in forward to get context indices
                if span1.end <= span2.start:
                    context_indices = list(range(span1.end, span2.start))
                elif span2.end <= span1.start:
                    context_indices = list(range(span2.end, span1.start))
                else:
                    context_indices = []

                if not context_indices:
                    context_indices = [span2.start]

                for i in context_indices:
                    d_tokvec[i] += d_ents[ent_index]
                    count_occ[i] += 1

                    ent_index += 1

            d_tokvec /= (count_occ + 1e-8)
            d_tokvecs.append(d_tokvec)

        d_docs = bp_tokvecs(d_tokvecs)
        return d_docs

################

    return relations, backprop

def instance_init(model: Model, X: List[Doc] = None, Y: Floats2d = None) -> Model:
    tok2vec = model.get_ref("tok2vec")
    if X is not None:
        tok2vec.initialize(X)
    return model
