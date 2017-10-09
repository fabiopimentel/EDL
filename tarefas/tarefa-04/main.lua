LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS_TELA = 12
FIM_JOGO=false
METEOROS_ABATIDOS = 0


local aviao_14bis={
	abatido = false,
	img = "imagens/nave.png",
	largura = 55,
	altura = 62,
	x = 320/2 - 64/2,
	y = 480 - 63,
	tiros = {}

}

local function destroi_14bis()

	destruicao:play()

	aviao_14bis["img"] = love.graphics.newImage("imagens/explosao_nave.png")
	aviao_14bis["largura"] = 67
	aviao_14bis["altura"] = 77
	
	game_over:play()

end



local function move_14bis()

	if love.keyboard.isDown("w") then
		aviao_14bis["y"] = aviao_14bis["y"]-2
	end	
	if love.keyboard.isDown("s") then
		aviao_14bis["y"] = aviao_14bis["y"]+2
	end	
	if love.keyboard.isDown("a") then
		aviao_14bis["x"] = aviao_14bis["x"]-2
	end	
	if love.keyboard.isDown("d") then
		aviao_14bis["x"] = aviao_14bis["x"]+2
	end		
 end

 

local function da_tiro()
	local tiro = {
		-- tiro sai do meio do aviao
		x= aviao_14bis["x"]+26,
		y= aviao_14bis["y"],
		largura= 16,
		altura = 16

	}
	shoot:play()
	table.insert(aviao_14bis["tiros"],tiro)
end

local function move_tiros()
	for key,tiro in pairs(aviao_14bis["tiros"]) do
		if tiro["y"] >= 0 then
			tiro["y"] = tiro["y"] -1
		else 
			-- remove tiro da memoria qdo sair da tela
			table.remove(aviao_14bis["tiros"], key)
		end	
	end
end

local meteoros = {}

local function cria_meteoros()
	local meteoro = {
		x= math.random(LARGURA_TELA),
		y= -10,
		peso = math.random(3),
		deslocamento_lateral = math.random(-1,1),
		largura = 50,
		altura = 44
		
	}
	table.insert(meteoros, meteoro)
end

local function move_meteoros()
	for key,meteoro in pairs(meteoros) do
		if meteoro["y"] <= ALTURA_TELA then
			meteoro["y"] = meteoro["y"] + meteoro["peso"]
			meteoro["x"] = meteoro["x"]+meteoro["deslocamento_lateral"]
	
		else 
			-- remove meteoro da memoria qdo sair da tela
			table.remove(meteoros, key)
		end	
	end
end

local function checa_colisao(x1,y1,L1,A1, x2,y2,L2,A2)

	return 	x1 < x2+L2 and
			x2 < x1+L1 and
			y1 < y2+A2 and
			y2 < y1+A1
	
end



local function tem_colisao_com_aviao14bis()


	for key,meteoro in pairs(meteoros) do
		
		if checa_colisao(meteoro["x"], meteoro["y"],meteoro["largura"], meteoro["altura"],
						aviao_14bis["x"], aviao_14bis["y"],aviao_14bis["largura"], aviao_14bis["altura"]) then

			
			return true				

		end	
	end

end	
	
local function checa_colisao_com_tiros()
	
	
	for key_m,meteoro in pairs(meteoros) do
		for key_t,tiro in pairs(aviao_14bis["tiros"]) do
			if checa_colisao(meteoro["x"], meteoro["y"],meteoro["largura"], meteoro["altura"],
							tiro["x"], tiro["y"],tiro["largura"], tiro["altura"]) then
				
				-- remove o tiro e o meteoro da tela				
				table.remove(meteoros, key_m)
				table.remove(aviao_14bis["tiros"],key_t)

				
		METEOROS_ABATIDOS = METEOROS_ABATIDOS+1
	
			end	
		end
	end

end

local function troca_musica_do_jogo_para(razao)
	music:stop()

	if razao == "FIM" then
		game_over:play()
	elseif razao == "VENCEDOR" then
		winner:play()
	end
	
end

local function checa_colisoes()
		
	if tem_colisao_com_aviao14bis() then
		destroi_14bis()
		troca_musica_do_jogo_para("FIM")
		FIM_JOGO = true
	end	
	checa_colisao_com_tiros() 
end	

local function checa_objetivo_concluido()
	if METEOROS_ABATIDOS == 100 then
		VENCEDOR = true
		troca_musica_do_jogo_para("VENCEDOR")
	end	
end	

function love.load()

	love.window.setMode(320, 480, {resizable=false})
	love.window.setTitle("14bis vs 100 meteóros")

	math.randomseed(os.time())

	background = love.graphics.newImage("imagens/background.png")
	tiro_img = love.graphics.newImage("imagens/shoot.png")
	meteoro_img = love.graphics.newImage("imagens/meteor.png")
	gameover_img = love.graphics.newImage("imagens/gameover.png")
	vencedor_img = love.graphics.newImage("imagens/vencedor.png")

	music = love.audio.newSource("sons/music.wav")
	music:setLooping(true)
	music:play()

	shoot = love.audio.newSource("sons/shoot.wav")
	destruicao = love.audio.newSource("sons/bomba.wav")
	game_over = love.audio.newSource("sons/game_over.wav")
	winner = love.audio.newSource("sons/winner.wav")

	aviao_14bis["img"] = love.graphics.newImage(aviao_14bis["img"])
	
end



function love.update(dt)
	if not FIM_JOGO and not VENCEDOR then
		if love.keyboard.isDown('w', 'a', 's', 'd') then
			move_14bis()
		end
		move_tiros()
		if #meteoros < MAX_METEOROS_TELA then
			cria_meteoros()
		end
		move_meteoros()
		checa_colisoes()
		checa_objetivo_concluido()	
	end	
			
end

function love.keypressed( key )
	if key == "space" then
	   da_tiro()
	end
 end


function love.draw()
	
	love.graphics.draw(background,0,0)

	for key,meteoro in pairs(meteoros) do
		love.graphics.draw(meteoro_img, meteoro["x"], meteoro["y"])
	end
		
	for key,tiro in pairs(aviao_14bis["tiros"]) do
		love.graphics.draw(tiro_img, tiro["x"], tiro["y"])
	end
		
	love.graphics.draw(aviao_14bis["img"], aviao_14bis["x"], aviao_14bis["y"])
	love.graphics.print("Meteóros abatidos: ".. METEOROS_ABATIDOS, 0, 10)

	if FIM_JOGO then
		love.graphics.draw(gameover_img,LARGURA_TELA/2-100,ALTURA_TELA/2-100)
	end

	if VENCEDOR then
		love.graphics.draw(vencedor_img,LARGURA_TELA/2-100,ALTURA_TELA/2-100)
	end	
		




end

