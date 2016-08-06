-- charger les tiles du fond
-- cherger les images des ennemis
-- charger les sons
-- faire un niveau
-- gerer les tirz
-- gerer les bonus
-- afficher un ecran d'accueil
-- gerer le score
-- gerer energie player
-- gerer les ennemis

io.stdout:setvbuf('no')

love.graphics.setDefaultFilter('nearest')

if arg[#arg] == "-debug" then
  require("mobdebug").start()
end
-- Constantes
VITESSE_PLAYER= 5
VITESSE_TIR_PLAYER = -10

BORDURE_EXTENSION = 75 

-- Chargement des Tiles

-- Chargement des Sons
sonTirPlayer = love.audio.newSource("sons/sonTirPlayer.wav", "static")

-- Création des listes
liste_sprites = {}
liste_tirs = {}
liste_enemies = {}

-- Création Joueur
player = {}

-- Création caméra
camera = {}
camera.x = 0

function CreateSprite(pNomImage,pX, pY)
  sprite = {}
  
  table.insert(liste_sprites, sprite)
  
  sprite.x = pX
  sprite.y = pY

  sprite.image = love.graphics.newImage("images/"..pNomImage..".png")
  sprite.l = sprite.image:getWidth()
  sprite.h = sprite.image:getHeight()
  sprite.supprime = false
  
  return sprite
end

function CreateTir(pType, pNomImage, pX, pY, pVitesse_x, pVitesse_y)
  local tir = CreateSprite(pNomImage, pX, pY)
  
  tir.type = pType
  tir.vx = pVitesse_x
  tir.vy = pVitesse_y
  tir.supprime = false
  
  table.insert(liste_tirs, tir)
  sonTirPlayer:play()
  
end

function CreateEnemies(pType, pNomImage, pX, pY)
  
end

function love.load()
  love.window.setMode(1024, 700)
  love.window.setTitle("1942 - Gamecoder")
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  player = CreateSprite("player", largeur / 2, hauteur /2)
  player.y = hauteur - player.h
  
  player2 = CreateSprite("player", largeur / 2, hauteur /2)
end

function love.update(dt)
  update_tirs()
  update_sprites()
  update_clavier()
end

function update_tirs()
  local n
  
  for n = #liste_tirs, 1, -1 do
    local tir = liste_tirs[n]
    tir.x = tir.x + tir.vx
    tir.y = tir.y + tir.vy
    
    if tir.y < -10 or tir.y > hauteur + 10 then
      tir.supprime = true
      table.remove(liste_tirs, n)
    end
  end
end

function update_sprites()
  local n
  
  for n = #liste_sprites, 1, -1 do
    local sprite = liste_sprites[n]
    if sprite.supprime == true then
      table.remove(liste_sprites, n)
    end
  end
end

function update_clavier()
  if love.keyboard.isDown("right") and player.x < largeur + BORDURE_EXTENSION - player.l / 2 then
    if player.x > largeur - BORDURE_EXTENSION - camera.x and camera.x > - BORDURE_EXTENSION * 2 then  -- Permet le deplacement seulement quand l'avion s'approche d'un bord et pour un debattement double a la constante BORDURE_EXTENSION
      camera.x = camera.x - 5
    end
    player.x = player.x + VITESSE_PLAYER
  end
  if love.keyboard.isDown("left") and player.x > - BORDURE_EXTENSION + player.l / 2 then
    if player.x < BORDURE_EXTENSION - camera.x  and camera.x < BORDURE_EXTENSION * 2 then
      camera.x = camera.x + 5
    end
    player.x = player.x - VITESSE_PLAYER
  end
  if love.keyboard.isDown("up") and player.y > player.h / 2 then
    player.y = player.y - VITESSE_PLAYER
  end
  if love.keyboard.isDown("down") and player.y < hauteur - player.h / 2 then
    player.y = player.y + VITESSE_PLAYER
  end
end

function love.draw()
  local n
  for n=1, #liste_sprites do
    local s = liste_sprites[n]
    love.graphics.draw(s.image, s.x + camera.x, s.y, 0, 1, 1, s.l / 2, s.h / 2)
  end
  
  love.graphics.print("Total Sprite : "..#liste_sprites.." Total Tir : "..#liste_tirs, 0, 0)
end

function love.keypressed(key)
  if key == "space" then
    CreateTir("player", "tir_player", player.x, player.y - player.h / 2, 0 , VITESSE_TIR_PLAYER)
  end
end
