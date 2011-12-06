#--
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'refining'

class Module
	private

	def __overload (name)
		overloaded = (__overloaded__[name] ||= {})
		overloaded[@__to_overload__ || :default] = instance_method(name)

		remove_instance_variable :@__to_overload__

		define_method name do |*args, &block|
			overloaded.each {|signature, body|
				next if signature == :default || signature.each_with_index.any? {|klass, index|
					!args[index].is_a?(klass)
				}

				return body.bind(self).call(*args, &block)
			}

			return overloaded[:default].bind(self).call(*args, &block) if overloaded[:default]

			raise ArgumentError, "the arguments don't match any signature"
		end
	end

	def __overloaded__
		@__overloaded__ ||= {}
	end

	public

	def is_overloaded? (name)
		__overloaded__.has_key?(name)
	end

	def def_signature (*sign)
		@__to_overload__ = sign
	end

	def define_overloadable (name, default = nil, matchers)
		define_method name do |*args|
			matchers.each {|signature, body|
				return instance_exec *args, &body if (signature.is_a?(Array) ? signature : [signature]).each_with_index.all? {|klass, index|
					args[index].is_a?(klass)
				}
			}

			return instance_exec *args, &default if default

			raise ArgumentError, "the arguments don't match any signature"
		end
	end

	refine_method :method_added, :prefix => '__overload' do |name|
		next if name == 'temporary method for refining'

		if !@__overloading__ && (@__to_overload__ || is_overloaded?(name))
			@__overloading__ = true
			__overload(name)
			remove_instance_variable :@__overloading__
		end

		__overload_method_added(name)
	end
end
