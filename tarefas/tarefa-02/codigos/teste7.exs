defmodule Calculadora do
	defmacro debug(expressao_quote) do
		
		expressao_string = Macro.to_string(expressao_quote)

		quote do
			resultado = unquote(expressao_quote)
			Calculadora.print(unquote(expressao_string), resultado)
			resultado
		end
 			
	end

	def print(string_representation, result) do
    	IO.puts "Resultado de #{string_representation}: #{result}"
  	end
end

defmodule Main do
  require Calculadora

  def test do
    Calculadora.debug(1+2)
    Calculadora.debug(1*2)
    Calculadora.debug(5-1)
  end
end

Main.test
