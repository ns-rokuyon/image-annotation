# coding: utf-8
require 'sinatra/base'

module Sinatra
    module AnnotationHelper
        Annotations = Struct.new(:name, :route, :description)
        def route_annotation
            @annotations = [
                Annotations.new("Label", "annotation/label", "annotate label to images")
            ]
        end
    end

    helpers AnnotationHelper
end

