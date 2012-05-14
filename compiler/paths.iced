path = require 'path'

buildSubdirectoryPaths = (paths, nextSegment, moreSegments...) ->
    return unless nextSegment?
    subdirectory = paths[nextSegment] ?= (pathFragments...) ->
        paths nextSegment, pathFragments...
    buildSubdirectoryPaths subdirectory, moreSegments...

Paths = (root, subdirectories...) ->
    result = (pathFragments...) ->
        path.resolve(root, pathFragments...)
    for subdirectory in subdirectories
        segments = subdirectory.split '/'
        buildSubdirectoryPaths result, segments...
    return result

module.exports = Paths