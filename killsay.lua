local Kill_String = 'Tapped by Shaxzyware.cc';
local Death_String = 'Nice baim lul';

function CHAT_KillSay( Event )

   if ( Event:GetName() == 'player_death' ) then

       local ME = client.GetLocalPlayerIndex();

       local INT_UID = Event:GetInt( 'userid' );
       local INT_ATTACKER = Event:GetInt( 'attacker' );

       local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
       local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );

       local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
       local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );

       if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then

           client.ChatSay( ' ' .. tostring( Kill_String ) .. ' ' .. NAME_Victim );

       elseif ( INDEX_Victim == ME and INDEX_Attacker ~= ME ) then

           client.ChatSay( ' ' .. tostring( Death_String ) .. ' ' .. NAME_Attacker );

       end
   
   end

end

client.AllowListener( 'player_death' );

callbacks.Register( 'FireGameEvent', 'AWKS', CHAT_KillSay );
