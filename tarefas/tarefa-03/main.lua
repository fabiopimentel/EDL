function inicia_dia()
	nuvem = love.graphics.newImage("nuvem-dia.png")
	love.graphics.setBackgroundColor( 255, 255, 255 )
	dia = true
end

function love.load()

	inicia_dia()
	
	largura_nuvem, altura_nuvem = nuvem:getDimensions( )
	largura_janela, altura_janela = love.graphics:getDimensions( )
	x=0
	y=0
 
end
 
function love.update(dt)
	if(x<largura_janela)
	then
		x=x+10
	 
	else
		-- quando a imagem passa da tela ela deveria voltar, dando um efeito de rotacao.
		x=-largura_nuvem

		-- Além dela vir mais para baixo, deveria subir caso fique no final da janela	
		y=y+100
			if(y+altura_nuvem>altura_janela)
			then
				y=0
				trocaTurno()
			end
	end	
 
end
 
function love.draw()
	love.graphics.draw(nuvem,x,y)
end

function trocaTurno()
	if dia == true
	then
		dia = false
		love.graphics.setBackgroundColor( 0, 0, 0 )
		nuvem = love.graphics.newImage("nuvem-noite.png")
	else	
		inicia_dia()
	end
end		