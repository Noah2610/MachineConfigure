####################################################
## Simple command-line arguments / options parser ##
##  https://github.com/Noah2610/ArgumentParser    ##
####################################################

class ArgumentParser
	def self.get_arguments valid_args = {}
		return nil  if (valid_args.nil? || valid_args.empty?)

		ret = {
			options:  {},
			keywords: {}
		}

		set_opt_val_of = nil
		set_kw_val_of = nil
		cur_kw_chain = nil
		read_user_inputs = false
		## Loop through all command-line arguments
		ARGV.each do |argument|

			## Check valid SINGLE options
			if (argument =~ /\A-[\w\d]+\z/)
				## Get all options of argument
				cur_opts = argument.sub(/\A-/,"").split("")
				valid_args[:single].each do |id, val|
					## Loop through every command-line option of current argument
					#  ex.: -abc -> a,b,c
					cur_opts.each do |opt|
						if (val.first.include? opt)
							## Check if option takes value
							if (val.last)
								ret[:options][id] = nil
								set_opt_val_of = id
							else
								ret[:options][id] = true
							end
						end
					end
				end

			## Check valid DOUBLE options
			elsif (argument =~ /\A--[\w\d\-]+\z/)
				cur_opt = argument.sub(/\A--/,"")
				valid_args[:double].each do |id, val|
					if (val.first.include? cur_opt)
						## Check if option takes value
						if (val.last)
							ret[:options][id] = nil
							set_opt_val_of = id
						else
							ret[:options][id] = true
						end
					end
				end

			## Check valid KEYWORDS or values
			elsif !(argument =~ /\A-{1,2}/)
				## Set value of previously found option
				if (set_opt_val_of)
					ret[:options][set_opt_val_of] = argument
					set_opt_val_of = nil
					next
				elsif (set_kw_val_of)
					ret[:keywords][set_kw_val_of] << argument
					set_kw_val_of = nil
					next
				end

				## Check if in kw-chain or for valid keyword
				if (cur_kw_chain.nil?)
					valid_args[:keywords].each do |id, val|
						if ([:INPUT, :INPUTS].include?(val.first) || val.first.include?(argument))
							ret[:keywords][id] = [argument]
							cur_kw_chain = id
							break
						end
					end
				else
					## Check if argument is valid for next kw in kw-chain
					kw_chain_index = ret[:keywords][cur_kw_chain].size
					## Read unlimited custom user input
					if (read_user_inputs)
						ret[:keywords][cur_kw_chain] << argument
						next
					else
						## If not unlimited custom user input and argument's length has exceeded
						## keyword-chain's possible length, then skip
						next  if (kw_chain_index >= valid_args[:keywords][cur_kw_chain].size)
					end
					if    (valid_args[:keywords][cur_kw_chain][kw_chain_index] == :INPUT)
						## Custom user input (single)
						ret[:keywords][cur_kw_chain] << argument

					elsif (valid_args[:keywords][cur_kw_chain][kw_chain_index] == :INPUTS)
						## Custom user input (unlimited)
						ret[:keywords][cur_kw_chain] << argument
						read_user_inputs = true

					else
						if (valid_args[:keywords][cur_kw_chain][kw_chain_index].include? argument)
							ret[:keywords][cur_kw_chain] << argument
						end
					end
				end
			end

		end  # end arguments loop

		return ret
	end
end
