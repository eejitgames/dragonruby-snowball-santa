def calc
end

=begin
Function DoSanta()
	State$ = SantaSPR.State$

	RowY = FLOOR ((MY#-(TileSize#/2))/TileSize#) + 1
	If RowY < 1 then RowY = 1	:	If RowY > 6 then RowY = 6
	SetSpriteY(RowSPR, (RowY*TileSize#)-22)
	If LMBPressed and Elves[RowY].State$ = "ready" then MoveElf(RowY)


	
	If State$ = "ready"
		If SantaSPR.NextAction# <= Timer()
			SantaBot()
		EndIf
	EndIf
	
	If State$ = "running"
		SantaY# = GetSpriteYByOffset(SantaSPR.ID)
		TargetY# = SantaSPR.Y*TileSize#
		Move# = SantaSPR.Speed#*GetFrameTime()
		If ABS(SantaY#-TargetY#) > 10.0
			If TargetY# < SantaY# then DIR = -1 Else DIR = 1
			ThisY# = DIR * Move# // ThisY# = DIR*(SantaSPR.Speed#*GetFrameTime())
			SetSpritePositionByOffset(SantaSPR.ID, GetSpriteXByOffset(SantaSPR.ID), SantaY# + ThisY#)
		Else
			SetSpritePositionByOffset(SantaSPR.ID, GetSpriteXByOffset(SantaSPR.ID), TargetY# )
			StopSprite(SantaSPR.ID)
			SetSpriteFrame(SantaSPR.ID,1)
			SantaSPR.State$ = "ready"
		EndIf
	EndIf
	
	If State$ = "shooting"
		If GetSpritePlaying(SantaSPR.ID) = 0
			AddSnowBall()
			SetSpriteFrame(SantaSPR.ID,1)
			SantaSPR.State$ = "ready"
		EndIf
	EndIf
EndFunction
=end
