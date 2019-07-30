import tensorflow as tf

const_node_1 = tf.constant(1.0, dtype=tf.float32)
const_node_2 = tf.constant(2.0, dtype=tf.float32)
const_node_3 = tf.constant([3.0, 4.0, 5.0], dtype=tf.float32)

adder_node_1 = tf.add(const_node_1, const_node_2)
adder_node_2 = const_node_1 + const_node_2

mult_node_2 = adder_node_2 * const_node_3


session = tf.Session()
print(session.run([adder_node_1]))
print(session.run([mult_node_2]))

print(const_node_1)
print(const_node_2)