import tensorflow as tf

placeholder_1 = tf.placeholder(dtype=tf.float32)
placeholder_2 = tf.placeholder(dtype=tf.float32)

multiply_node_1 = placeholder_1 * 3
multiply_node_2 = placeholder_1 * placeholder_2

session = tf.Session()
print(session.run(placeholder_1, {placeholder_1: [1.0, 2.0, 3.0]}))

print(session.run(multiply_node_1, {placeholder_1: 4.0}))
print(session.run(multiply_node_2, {placeholder_1: 3.0, placeholder_2: [2.0, 5.0]}))