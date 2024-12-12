local Tutorialmod = RegisterMod("Isaac Gallery Tutorial", 1)
--Tutorialmod는 앞으로 이 모드 자체를 코드 내에서 가리킬 때 지겹게 쓰게 될 것이다.
--소형 모드라 굳이 호환성은 필요 없기에, 'local'은 아직은 떼지 말자.
--모드가 커진다면, 모드의 명칭을 다른 코드에서 건드릴 일이 생길테니, 모드 명칭 앞에 '로컬' 붙이면 안 됨
--글자들 앞에 "-"를 두 번 연달아 쓰면 그 줄 한정, 뒤에 오는 모든 글자가 녹색으로 변한다. 녹색 텍스트는 코드 실행 시 무시된다.

local TUTORIAL_ITEM_ID = Isaac.GetItemIdByName("C-section on crack")
--이 아이템의 ID가 필요할 때마다 TUTORIAL_ITEM_ID 를 쓰면 된다.
--local이 앞에 붙었으므로 다른 코드에서 TUTORIAL_ITEM_ID 를 쓸 수 없음에 주의!

local tearsmult = 1.5
--아 아이템의 연사력 배수다. 미리 안 정해두면 존나 귀찮아지니 미리 정의해두기로 했다.

function Tutorialmod:HandleTutorialItem(player, flag)  --플레이어: 아이템 소지 중인 플레이어, 플래그: 능력치 계산 시 쓰이는 플래그
    if player:HasCollectible(TUTORIAL_ITEM_ID) then --플레이어가 튜토리얼 아이템을 들고 있다면...
	
	if flag == CacheFlag.CACHE_DAMAGE then --데미지가 갱신될 때마다
        player.Damage = player.Damage + 1.5 --지금까지 계산한 데미지에 1.5를 더한다. 즉, 소지 시 공격력 +1.5
    end	

	if flag == CacheFlag.CACHE_TEARFLAG then --눈물에 붙어있는 특수 효과가 갱신될 때마다...
        player.TearFlags = player.TearFlags | TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_KNIFE | TearFlags.TEAR_SPECTRAL
		--눈물에 씨섹 태아 효과가 붙으며, 태아가 칼을 들고 있게 된다
		--TearFlags.TEAR_SPECTRAL은 지형 관통 눈물 효과다
		--TearFlags.TEAR_FETUS_KNIFE는 TearFlags.TEAR_FETUS와 함께 쓰지 않으면 효과가 없으니 주의!
		--기존 눈물 효과는 유지되니까, 갓헤드를 들고 있다면 갓헤다 씨섹 식칼 태아가 나간다.
		--플래그를 여러 개 붙이려면 "|"를 원하는 플래그들 사이에 적으면 된다.
		
		--혈사, 식칼 같은 건 눈물 효과가 아니라 '무기 변경'이니까 여기서는 다루지 않기로 한다.
    end
	
	if flag == CacheFlag.CACHE_FIREDELAY then --연사력 갱신 시마다...
        player.MaxFireDelay = ( player.MaxFireDelay / tearsmult ) - (( tearsmult -1 )/ tearsmult )
    end	
	    --연사력을 1.5배 올린다. 아까 위에서 "local tearsmult = 1.5"로 연사 배수는 정해줬다.
		--연사력 스탯만 이따위인 이유는 연사력 공식부터가 엉망이기 때문이다.

	end
end
Tutorialmod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Tutorialmod.HandleTutorialItem)
--ModCallbacks.MC_EVALUATE_CACHE: 능력치가 갱신될때마다 이 코드를 실행해서, 새로운 능력치 계산 결과를 실제 능력치에 반영함
--items.xml에서 cacheflags 부분을 제대로 지정해주지 않으면 이 효과가 제대로 반영되지 않으니 주의!

function Tutorialmod:postFireTear(tear) --이 함수 내에서 tear는 '눈물'를 가리킨다.
    local parent = tear.SpawnerEntity --눈물 소환한 놈을 지정해준다.
    if not parent then return end --눈물 소환한 놈이 없으면 이 코드를 실행하지 않는다.
    local player = parent:ToPlayer() --눈물 소환한 놈이 '플레이어'임을 컴퓨터에게 알려준다.
    if not player then return end --눈물을 소환한 플레이어가 없으면 이 코드를 실행하지 않는다.
	
if player:HasCollectible(TUTORIAL_ITEM_ID) then --튜토리얼 아이템을 플레이어가 소지하고 있다면...
  tear:ChangeVariant(TearVariant.FETUS) --눈물 모양을 씨섹 태아로 변경
 
local retard = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, player.Position, Vector.Zero, player):ToEffect() 
retard.Color = Color(0,0,1,0.5,0,0,1) --방귀를 파랗게 칠한다.
--눈물을 쏠 때마다 플레이어 위치에 방귀 이펙트를 생성
--이 function 외부에서 retard 변수를 써도 소용 없다. local이 앞에 붙었기 때문에, 이 함수 밖에서 이 값을 불러오려고 하면 아무 값도 없는 nil이 나온다.
  
end
  
end
Tutorialmod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Tutorialmod.postFireTear)
--ModCallbacks.MC_POST_FIRE_TEAR: 눈물을 쏠 때마다 이 코드를 실행함.