# coding: utf-8

class ImageAnnotationAppError < StandardError; end

class AnnotationDBError < ImageAnnotationAppError; end
class HelperError < ImageAnnotationAppError; end
class LabelHelperError < HelperError; end
