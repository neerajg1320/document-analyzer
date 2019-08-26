export default {
  getResourceFromPath(path) {
    const path_split_array = path.split('/');

    var resource_name = "none";
    if (path_split_array.length > 2) {
      resource_name = path_split_array[2];
    }

    return resource_name;
  }
}
