classdef SumDim < dagnn.ElementWise
  %SUM DagNN sum layer
  %   The SUM layer takes the sum of all its inputs and store the result
  %   as its only output.

  properties (Transient)
    dim = 3
  end

  methods
    function outputs = forward(obj, inputs, params)
      % obj.numInputs = numel(inputs) ;
      tmp        = inputs{1}; 
      outputs{1} = 1e-6 .* ones(size(tmp, 1), size(tmp, 2), 1, size(tmp, 4));
      % Avoid summation results a zero weights 
      for k = 1:size(inputs{1}, 3)
        outputs{1} = outputs{1} + tmp(:, :, k, :) ;
      end
      
      % Avoud
    end

    function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
      derInput = gpuArray(zeros(size(inputs{1}))); 
      for k = 1:size(inputs{1}, 3)
        derInput(:, :, k, :) = derOutputs{1} ;
      end
      derInputs = {derInput}; 
      derParams = {} ;
    end

    function outputSizes = getOutputSizes(obj, inputSizes)
      outputSizes{1} = inputSizes{1} ;
      for k = 2:numel(inputSizes)
        if all(~isnan(inputSizes{k})) && all(~isnan(outputSizes{1}))
          if ~isequal(inputSizes{k}, outputSizes{1})
            warning('Sum layer: the dimensions of the input variables is not the same.') ;
          end
        end
      end
    end

    function rfs = getReceptiveFields(obj)
      numInputs = numel(obj.net.layers(obj.layerIndex).inputs) ;
      rfs.size = [1 1] ;
      rfs.stride = [1 1] ;
      rfs.offset = [1 1] ;
      rfs = repmat(rfs, numInputs, 1) ;
    end

    function obj = Sum(varargin)
      obj.load(varargin) ;
    end
  end
end
