//-----------------------------------------------------------------------
//------------------- Copyright (c) samisalreadytaken -------------------
//- v2.36.7 -------------------------------------------------------------
if("VS"in::getroottable()&&typeof::VS=="table"&&"_xa9b2dfB7ffe"in::getroottable()&&!::VS._reload&&::ENT_SCRIPT.IsValid())return;;local _v2=function(){}local _f=_v2.getinfos().src;_f=_f.slice(0,_f.find(".nut"));if(this!=::getroottable())return::DoIncludeScript(_f,::getroottable());;if(_f!="vs_library")::print("Loading vs_library...\n");;::VS<-{slots_entity=["DispatchOnPostSpawn","self","__vname","PrecacheCallChain","OnPostSpawnCallChain","__vrefs","DispatchPrecache","activator","caller","OnPostSpawn","PostSpawn","Precache","PreSpawnInstance","__EntityMakerResult","__FinishSpawn","__ExecutePreSpawn"],slots_root=["CHostage","split","Vector","print","_floatsize_","ScriptIsLocalPlayerUsingController","GetDeveloperLevel","ScriptGetBestTrainingCourseTime","exp","CSceneEntity","ScriptCoopMissionRespawnDeadPlayers","DispatchParticleEffect","CTriggerCamera","DoEntFire","seterrorhandler","RandomFloat","CBasePlayer","VSquirrel_OnReleaseScope","ScriptCoopMissionSetNextRespawnIn","assert","atan2","ScriptCoopMissionSpawnNextWave","DoUniqueString","_charsize_","asin","atan","CBaseAnimating","cos","ScriptPrintMessageCenterTeam","EntFireByHandle","PI","Entities","SendToConsole","TraceLine","strip","ScriptCoopMissionGetMissionNumber","newthread","lstrip","ScriptCoopSetBotQuotaAndRefreshSpawns","ScriptPrintMessageChatTeam","IncludeScript","format","rstrip","acos","ScriptGetPlayerCompletedTraining","Documentation","__DumpScope","CEntities","abs","PrintHelp","ScriptPrintMessageCenterAllWithParams","CBaseEntity","FrameTime","Time","Assert","ScriptCoopGiveC4sToCTs","DebugDrawBox","DebugDrawLine","ScriptHighlightAmmoCounter","Document","_intsize_","collectgarbage","setroottable","ScriptSetMiniScoreHidden","ScriptCoopCollectBonusCoin","CBaseFlex","ScriptPrintMessageCenterAll","ScriptSetRadarHidden","enabledebuginfo","setdebughook","ceil","log10","CGameSurvivalLogic","RecordAchievementEvent","RAND_MAX","rand","srand","GetFunctionSignature","suspend","ScriptIsWarmupPeriod","VSquirrel_OnCreateScope","ScriptShowFinishMsgBox","developer","CEnvEntityMaker","__ReplaceClosures","compilestring","RetrieveNativeSignature","ScriptShowExitDoorMsg","SendToConsoleServer","GetMapName","EntFire","Msg","UniqueString","sqrt","ScriptGetRoundsPlayed","floor","CreateSceneEntity","getstackinfos","ScriptGetGameType","log","fabs","dummy","DoIncludeScript","LateBinder","getroottable","tan","ShowMessage","array","LoopSinglePlayerMaps","_version_","ScriptGetValveTrainingCourseTime","setconsttable","CreateProp","printl","CFuncTrackTrain","sin","getconsttable","pow","CGameCoopMissionManager","ScriptSetPlayerCompletedTraining","CBaseMultiplayerPlayer","RegisterFunctionDocumentation","CPlayerVoiceListener","ScriptSetBestTrainingCourseTime","ScriptTrainingGivePlayerAmmo","ScriptCoopResetRoundStartTime","CScriptKeyValues","type","CCallChainer","CSimpleCallChainer","ScriptPrintMessageChatAll","ScriptGetGameMode","regexp","RandomInt","ScriptCoopMissionSpawnFirstEnemies","ScriptCoopExtendRoundDurationTime","ScriptCoopToggleEntityOutlineHighlights","ScriptMissionResetDangerZones","ScriptMissionCreateAndDetonateDangerZone","ScriptCoopMissionSetDeadPlayerRespawnEnabled"],slots_VS=["_xa9b2dfB7ffe","VS","DoEntFireByInstanceHandle","ClearChat","Chat","ChatTeam","txt","Alert","AlertTeam","PrecacheModel","PrecacheScriptSound","delay","OnGameEvent_player_spawn","OnGameEvent_player_connect","VecToString","ENT_SCRIPT","HPlayer","SPlayer","Ent","Entc","max","min","clamp","MAX_COORD_FLOAT","MAX_TRACE_LENGTH","DEG2RAD","RAD2DEG","CONST","vs_library"],slots_valve=[],slots_default=[],Events={},Log={condition=false,export=false,filePrefix="vs.log",L=[],filter="VFLTR"},_reload=false}VS.slots_valve.extend(VS.slots_entity);VS.slots_valve.extend(VS.slots_root);VS.slots_default.extend(VS.slots_valve);VS.slots_default.extend(VS.slots_VS);::CONST<-::getconsttable();::vs_library<-"vs_library 2.36.7";::MAX_COORD_FLOAT<-16384.0;::MAX_TRACE_LENGTH<-56755.84086241;::DEG2RAD<-0.01745329;::RAD2DEG<-57.29577951;::RAND_MAX<-32767;::txt<-{invis="\x00",white="\x01",red="\x02",purple="\x03",green="\x04",lightgreen="\x05",limegreen="\x06",lightred="\x07",grey="\x08",yellow="\x09",lightblue="\x0a",blue="\x0b",darkblue="\x0c",darkgrey="\x0d",pink="\x0e",orangered="\x0f",orange="\x10"}local _VEC=Vector();if(!("_xa9b2dfB7ffe"in::getroottable()))::_xa9b2dfB7ffe<-[];;if(!("OnGameEvent_player_spawn"in::getroottable()))::OnGameEvent_player_spawn<-::dummy;;if(!("OnGameEvent_player_connect"in::getroottable()))::OnGameEvent_player_connect<-::dummy;;if(::print.getinfos().native)::Msg<-::print;;if(::EntFireByHandle.getinfos().native)::DoEntFireByInstanceHandle<-::EntFireByHandle;;::Ent<-function(s,i=null)return::Entities.FindByName(i,s);::Entc<-function(s,i=null)return::Entities.FindByClassname(i,s);local _v0=function(){if(::ENT_SCRIPT<-::Entc("worldspawn")){::ENT_SCRIPT.ValidateScriptScope();::VS.slots_default.append(::VS.GetVarName(::ENT_SCRIPT.GetScriptScope()))}else{(::ENT_SCRIPT<-::VS.CreateEntity("soundent")).ValidateScriptScope();::VS._ENT_SCRIPT<-::ENT_SCRIPT;::print("ERROR: Could not find worldspawn\n")};::collectgarbage()}function VS::ForceReload():(_f){_reload=true;::print("Reloading vs_library...\n");return::DoIncludeScript(_f,::getroottable())}::max<-function(a,b)return a>b?a:b;::min<-function(a,b)return a<b?a:b;::clamp<-function(v,l,h){if(h<l){local t=h;h=l;l=t};return(v<l)?l:(h<v)?h:v}function VS::IsInteger(f)return::floor(f)==f;function VS::IsLookingAt(S,T,D,C){local t=T-S;t.Norm();return t.Dot(D)>=C}function VS::PointOnLineNearestPoint(s,e,p){local v=e-s,d=v.Dot(p-s)/v.LengthSqr();if(d<0.0)return s;else if(d>1.0)return e;else return s+v*d}function VS::GetAngle(F,T){local d=F-T,p=57.29577951*::atan2(d.z,d.Length2D()),y=57.29577951*(::atan2(d.y,d.x)+3.14159265);return::Vector(p,y,0.0)}function VS::GetAngle2D(f,T){local d=T-f,y=57.29577951*::atan2(d.y,d.x);return y}function VS::VectorVectors(f,r,u){if(f.x==0.0&&f.y==0.0){r.x=0.0;r.y=-1.0;r.z=0.0;u.x=-f.z;u.y=0.0;u.z=0.0}else{local R=f.Cross(::Vector(0.0,0.0,1.0));r.x=R.x;r.y=R.y;r.z=R.z;r.Norm();local U=r.Cross(f);u.x=U.x;u.y=U.y;u.z=U.z;u.Norm()}}function VS::AngleVectors(a,f=_VEC,r=null,u=null){local sr,cr,rr,yr=0.01745329*a.y,sy=::sin(yr),cy=::cos(yr),pr=0.01745329*a.x,sp=::sin(pr),cp=::cos(pr);if(a.z){rr=0.01745329*a.z;sr=::sin(rr);cr=::cos(rr)}else{sr=0.0;cr=1.0};if(f){f.x=cp*cy;f.y=cp*sy;f.z=-sp};if(r){r.x=(-1.0*sr*sp*cy+-1.0*cr*-sy);r.y=(-1.0*sr*sp*sy+-1.0*cr*cy);r.z=-1.0*sr*cp};if(u){u.x=(cr*sp*cy+-sr*-sy);u.y=(cr*sp*sy+-sr*cy);u.z=cr*cp};return f}function VS::VectorAngles(f){local t,y,p;if(f.y==0.0&&f.x==0.0){y=0.0;if(f.z>0.0)p=270.0;else p=90.0}else{y=57.29577951*::atan2(f.y,f.x);if(y<0.0)y+=360.0;t=::sqrt(f.x*f.x+f.y*f.y);p=57.29577951*::atan2(-f.z,t);if(p<0.0)p+=360.0};return::Vector(p,y,0.0)}function VS::VectorYawRotate(i,y,o=_VEC){local r=0.01745329*y,sy=::sin(r),cy=::cos(r);o.x=i.x*cy-i.y*sy;o.y=i.x*sy+i.y*cy;o.z=i.z;return o}function VS::YawToVector(y){local a=0.01745329*y;return::Vector(::cos(a),::sin(a),0.0)}function VS::VecToYaw(v){if(v.y==0.0&&v.x==0.0)return 0.0;local y=57.29577951*::atan2(v.y,v.x);if(y<0.0)y+=360.0;return y}function VS::VecToPitch(v){if(v.y==0.0&&v.x==0.0){if(v.z<0.0)return 180.0;else return-180.0};return 57.29577951*::atan2(-v.z,v.Length2D())}function VS::VectorIsZero(v)return v.x==v.y&&v.y==v.z&&v.z==0.0;function VS::VectorsAreEqual(a,b,t=0.0)return(::fabs(a.x-b.x)<=t&&::fabs(a.y-b.y)<=t&&::fabs(a.z-b.z)<=t);function VS::AnglesAreEqual(a,b,t=0.0)return::fabs(AngleDiff(a,b))<=t;function VS::CloseEnough(a,b,e)return::fabs(a-b)<=e;function VS::Approach(t,l,s){local dt=t-l;if(dt>s)l+=s;else if(-s>dt)l-=s;else l=t;;return l}function VS::ApproachAngle(T,V,S){T%=360.0;if(T>180.0)T-=360.0;else if(-180.0>T)T+=360.0;;V%=360.0;if(V>180.0)V-=360.0;else if(-180.0>V)V+=360.0;;local d=T-V;d%=360.0;if(d>180.0)d-=360.0;else if(-180.0>d)d+=360.0;;S=::fabs(S);if(d>S)V+=S;else if(-S>d)V-=S;else V=T;;return V}function VS::AngleDiff(d,s){local a=d-s;a%=360.0;if(a>180.0)a-=360.0;else if(-180.0>a)a+=360.0;;return a}function VS::AngleNormalize(a){a%=360.0;if(a>180.0)a-=360.0;else if(-180.0>a)a+=360.0;;return a}function VS::QAngleNormalize(A){A.x%=360.0;if(A.x>180.0)A.x-=360.0;else if(-180.0>A.x)A.x+=360.0;;A.y%=360.0;if(A.y>180.0)A.y-=360.0;else if(-180.0>A.y)A.y+=360.0;;A.z%=360.0;if(A.z>180.0)A.z-=360.0;else if(-180.0>A.z)A.z+=360.0;;return A}function VS::SnapDirectionToAxis(v,e=0.1){local p=1.0-e;if(::fabs(v.x)>p){if(v.x<0.0)v.x=-1.0;else v.x=1.0;v.y=0.0;v.z=0.0;return v};if(::fabs(v.y)>p){if(v.y<0.0)v.y=-1.0;else v.y=1.0;v.z=0.0;v.x=0.0;return v};if(::fabs(v.z)>p){if(v.z<0.0)v.z=-1.0;else v.z=1.0;v.x=0.0;v.y=0.0;return v}}function VS::Dist(v1,v2)return(v1-v2).Length();function VS::DistSqr(v1,v2)return(v1-v2).LengthSqr();function VS::VectorCopy(S,D){D.x=S.x;D.y=S.y;D.z=S.z;return D}function VS::VectorMin(a,b,o=_VEC){o.x=a.x<b.x?a.x:b.x;o.y=a.y<b.y?a.y:b.y;o.z=a.z<b.z?a.z:b.z;return o}function VS::VectorMax(a,b,o=_VEC){o.x=a.x>b.x?a.x:b.x;o.y=a.y>b.y?a.y:b.y;o.z=a.z>b.z?a.z:b.z;return o}function VS::VectorAbs(v){v.x=::fabs(v.x);v.y=::fabs(v.y);v.z=::fabs(v.z);return v}function VS::VectorAdd(a,b,o=_VEC){o.x=a.x+b.x;o.y=a.y+b.y;o.z=a.z+b.z;return o}function VS::VectorSubtract(a,b,o=_VEC){o.x=a.x-b.x;o.y=a.y-b.y;o.z=a.z-b.z;return o}function VS::VectorMultiply(a,b,o=_VEC){o.x=a.x*b;o.y=a.y*b;o.z=a.z*b;return o}function VS::VectorMultiply2(a,b,o=_VEC){o.x=a.x*b.x;o.y=a.y*b.y;o.z=a.z*b.z;return o}function VS::VectorDivide(a,b,o=_VEC){local d=1.0/b;o.x=a.x*d;o.y=a.y*d;o.z=a.z*d;return o}function VS::VectorDivide2(a,b,o=_VEC){o.x=a.x/b.x;o.y=a.y/b.y;o.z=a.z/b.z;return o}function VS::ComputeVolume(i,x){local d=x-i;return d.Dot(d)}function VS::RandomVector(i=-RAND_MAX,x=RAND_MAX)return::Vector(::RandomFloat(i,x),::RandomFloat(i,x),::RandomFloat(i,x));function VS::CalcSqrDistanceToAABB(n,x,p){local t,d=0.0;if(p.x<n.x){t=(n.x-p.x);d+=t*t}else if(p.x>x.x){t=(p.x-x.x);d+=t*t};;if(p.y<n.y){t=(n.y-p.y);d+=t*t}else if(p.y>x.y){t=(p.y-x.y);d+=t*t};;if(p.z<n.z){t=(n.z-p.z);d+=t*t}else if(p.z>x.z){t=(p.z-x.z);d+=t*t};;return d}function VS::CalcClosestPointOnAABB(n,x,p,o=_VEC){o.x=::clamp(p.x,n.x,x.x);o.y=::clamp(p.y,n.y,x.y);o.z=::clamp(p.z,n.z,x.z);return o}function VS::ExponentialDecay(d,i,t)return::exp(::log(d)/i*t);function VS::ExponentialDecay2(h,t)return::exp(-0.69314718/h*t);function VS::ExponentialDecayIntegral(d,i,t)return(::pow(d,t/i)*i-i)/::log(d);function VS::SimpleSpline(l){local s=l*l;return(3.0*s-2.0*s*l)}function VS::SimpleSplineRemapVal(V,A,B,C,D){if(A==B)return V>=B?D:C;local cv=(V-A)/(B-A);local vs=cv*cv;return C+(D-C)*(3.0*vs-2.0*vs*cv)}function VS::SimpleSplineRemapValClamped(V,A,B,C,D){if(A==B)return V>=B?D:C;local cv=(V-A)/(B-A);cv=(cv<0.0)?0.0:(1.0<cv)?1.0:cv;local vs=cv*cv;return C+(D-C)*(3.0*vs-2.0*vs*cv)}function VS::RemapVal(l,A,B,C,D){if(A==B)return l>=B?D:C;return C+(D-C)*(l-A)/(B-A)}function VS::RemapValClamped(V,A,B,C,D){if(A==B)return V>=B?D:C;local cv=(V-A)/(B-A);cv=(cv<0.0)?0.0:(1.0<cv)?1.0:cv;return C+(D-C)*cv}function VS::Bias(x,b){local a=-1.0,e=0.0;if(a!=b)e=::log(b)*-1.4427;return::pow(x,e)}function VS::Gain(x,bA){if(x<0.5){local IA=1.0-bA,la=-1.0,le=0.0;if(la!=IA)le=::log(IA)*-1.4427;return 0.5*::pow(2.0*x,le)}else{local IA=1.0-bA,la=-1.0,le=0.0;if(la!=IA)le=::log(IA)*-1.4427;return 1.0-0.5*::pow(2.0-2.0*x,le)}}function VS::SmoothCurve(x)return(1.0-::cos(x*3.14159265))*0.5;function VS::MovePeak(x,p){if(x<p)return x*0.5/p;else return 0.5+0.5*(x-p)/(1.0-p)}function VS::SmoothCurve_Tweak(x,pp,ps){local sh,mp=(x<pp)?(x*0.5/pp):(0.5+0.5*(x-pp)/(1.0-pp));if(mp<0.5){local IA=1.0-ps,la=-1.0,le=0.0;if(la!=IA)le=::log(IA)*-1.4427;sh=0.5*::pow(2.0*mp,le)}else{local IA=1.0-ps,la=-1.0,le=0.0;if(la!=IA)le=::log(IA)*-1.4427;sh=1.0-0.5*::pow(2.0-2.0*mp,le)};return(1.0-::cos(sh*3.14159265))*0.5}function VS::Lerp(A,B,f)return A+(B-A)*f;function VS::FLerp(f1,f2,i1,i2,x)return f1+(f2-f1)*(x-i1)/(i2-i1);function VS::VectorLerp(v1,v2,f,o=_VEC){o.x=v1.x+(v2.x-v1.x)*f;o.y=v1.y+(v2.y-v1.y)*f;o.z=v1.z+(v2.z-v1.z)*f;return o}function VS::IsPointInBox(v,i,x)return(v.x>=i.x&&v.x<=x.x&&v.y>=i.y&&v.y<=x.y&&v.z>=i.z&&v.z<=x.z);function VS::IsBoxIntersectingBox(i1,x1,i2,x2){if((i1.x>x2.x)||(x1.x<i2.x))return false;if((i1.y>x2.y)||(x1.y<i2.y))return false;if((i1.z>x2.z)||(x1.z<i2.z))return false;return true}::EntFireByHandle<-function(t,a,v="",d=0.0,o=null,c=null)return::DoEntFireByInstanceHandle(t,a.tostring(),v.tostring(),d,o,c);::PrecacheModel<-function(s)::ENT_SCRIPT.PrecacheModel(s);::PrecacheScriptSound<-function(s)::ENT_SCRIPT.PrecacheScriptSound(s);function VS::MakePermanent(h)return h.__KeyValueFromString("classname","soundent");function VS::SetParent(c,p){if(!p)return::DoEntFireByInstanceHandle(c,"setparent","",0.0,null,null);return::DoEntFireByInstanceHandle(c,"setparent","!activator",0.0,p,null)}function VS::ShowGameText(E,T,M=null,D=0.0){if(M)E.__KeyValueFromString("message",""+M);return::DoEntFireByInstanceHandle(E,"display","",D,T,null)}function VS::ShowHudHint(e,t,m=null,d=0.0){if(m)e.__KeyValueFromString("message",""+m);return::DoEntFireByInstanceHandle(e,"showhudhint","",d,t,null)}function VS::HideHudHint(e,t,d=0)return::DoEntFireByInstanceHandle(e,"hidehudhint","",d,t,null);function VS::CreateMeasure(g,n=null,p=0,e=1,s=1.0){local r=e?n?n.tostring():"vs.ref_"+UniqueString():n?n.tostring():null;if(!r||!r.len())throw"Invalid targetname";local e=CreateEntity("logic_measure_movement",{measuretype=e?1:0,measurereference="",targetreference=r,target=r,measureretarget="",targetscale=s.tofloat(),targetname=e?r:null},p);::DoEntFireByInstanceHandle(e,"setmeasurereference",r,0.0,null,null);::DoEntFireByInstanceHandle(e,"setmeasuretarget",g,0.0,null,null);::DoEntFireByInstanceHandle(e,"enable","",0.0,null,null);return e}function VS::SetMeasure(h,s)return::DoEntFireByInstanceHandle(h,"setmeasuretarget",s,0.0,null,null);function VS::CreateTimer(D,R,L=null,U=null,O=false,P=false){local e=CreateEntity("logic_timer",null,P);if(R){e.__KeyValueFromInt("UseRandomTime",0);e.__KeyValueFromFloat("RefireTime",R.tofloat())}else{e.__KeyValueFromFloat("LowerRandomBound",L.tofloat());e.__KeyValueFromFloat("UpperRandomBound",U.tofloat());e.__KeyValueFromInt("UseRandomTime",1);e.__KeyValueFromInt("spawnflags",O.tointeger())};::DoEntFireByInstanceHandle(e,D?"disable":"enable","",0.0,null,null);return e}function VS::Timer(b,f,s=null,t=null,e=false,p=false){if(!f){::print("\nERROR:\nRefire time cannot be null in VS.Timer\nUse VS.CreateTimer for randomised fire times.\n");throw"NULL REFIRE TIME"};local h=CreateTimer(b,f,null,null,null,p);OnTimer(h,s,t?t:GetCaller(),e);return h}function VS::OnTimer(E,F,S=null,B=false)return AddOutput(E,"OnTimer",F,S?S:GetCaller(),B);function VS::AddOutput(H,S,F,T=null,B=false){if(!T)T=GetCaller();if(F){if(typeof F=="string"){if(F.find("(")!=null)F=::compilestring(F);else F=T[F]}else if(typeof F!="function")throw"Invalid function type "+typeof F}else{F=null;B=true};H.ValidateScriptScope();local r=H.GetScriptScope();r[S]<-B?F:F.bindenv(T);H.ConnectOutput(S,S);return r}function VS::AddOutput2(E,O,F,S=null,I=false){if(E.GetScriptScope()||typeof F=="function")return AddOutput(E,O,F,S,I);if(typeof F!="string")throw"Invalid function type "+typeof F;if(!S)S=GetCaller();if(!I){if(!("self"in S))throw"Invalid function path. Not an entity";::DoEntFireByInstanceHandle(E,"addoutput",O+" "+S.self.GetName()+",runscriptcode,"+F,0.0,S.self,E)}else{local n=E.GetName();if(!n.len()){n=UniqueString();E.__KeyValueFromString("targetname",n)};::DoEntFireByInstanceHandle(E,"addoutput",O+" "+n+",runscriptcode,"+F,0.0,null,E)}}function VS::CreateEntity(C,K=null,P=false){local e=::Entities.CreateByClassname(C);if(typeof K=="table")foreach(k,v in K)SetKey(e,k,v);if(P)MakePermanent(e);return e}function VS::SetKey(e,k,v)switch(typeof v){case"bool":case"integer":return e.__KeyValueFromInt(k,v.tointeger());case"float":return e.__KeyValueFromFloat(k,v);case"string":return e.__KeyValueFromString(k,v);case"Vector":return e.__KeyValueFromVector(k,v);case"null":return true;default:throw"Invid input type: "+typeof v}function VS::SetName(e,s)return e.__KeyValueFromString("targetname",s.tostring());function VS::DumpEnt(I=null){if(!I){local e;while(e=::Entities.Next(e)){local s=e.GetScriptScope();if(s)::print(e+" :: "+s.__vname+"\n")}return};if(typeof I=="string")I=FindEntityByString(I);if(typeof I=="instance"){if(I.IsValid()){local s=I.GetScriptScope();if(s){::print("--- Script dump for entity "+I+"\n");DumpScope(s,0,1,0,1);::print("--- End script dump\n")}else return::print("Entity has no script scope! "+I+"\n")}else return::print("Invalid entity!\n")}else if(I){local e;while(e=::Entities.Next(e)){local s=e.GetScriptScope();if(s){::print("\n--- Script dump for entity "+e+"\n");DumpScope(s,0,1,0,1);::print("--- End script dump\n")}}}}function VS::DumpPlayers(D=false){local a=GetPlayersAndBots(),p=a[0],b=a[1];::print("\n=======================================\n"+p.len()+" players found\n"+b.len()+" bots found\n");local c=function(_s,_a):(D){foreach(e in _a){local s=e.GetScriptScope();if(s)s=GetVarName(s);if(!s)s="null";::print(_s+"- "+e+" :: "+s+"\n");if(D&&s!="null")DumpEnt(e)}}c("[BOT]    ",b);c("[PLAYER] ",p);::print("=======================================\n")}function VS::GetPlayersAndBots(){local e,E=::Entities,p=[],b=[];while(e=E.FindByClassname(e,"cs_bot"))b.append(e.weakref());e=null;while(e=E.FindByClassname(e,"player")){local s=e.GetScriptScope();if("networkid"in s&&s.networkid=="BOT")b.append(e.weakref());else p.append(e.weakref())}return[p,b]}function VS::GetAllPlayers(){local e,E=::Entities,a=[];while(e=E.Next(e))if(e.GetClassname()=="player")a.append(e.weakref());return a}function VS::GetLocalPlayer(){if(GetPlayersAndBots()[0].len()>1)::print("GetLocalPlayer: More than 1 player detected!\n");local e=Entc("player");if(e!=GetPlayerByIndex(1))::print("GetLocalPlayer: Discrepancy detected!\n");if(!e||!e.IsValid())return::print("GetLocalPlayer: No player found!\n");if(!e.ValidateScriptScope())return::print("GetLocalPlayer: Failed to validate player scope!\n");SetName(e,"localplayer");::SPlayer<-e.GetScriptScope();::HPlayer<-e.weakref();return e}function VS::GetPlayerByIndex(I){local e,E=::Entities;while(e=E.Next(e))if(e.GetClassname()=="player")if(e.entindex()==I)return e}function VS::FindEntityByIndex(i,s="*"){local e,E=::Entities;while(e=E.FindByClassname(e,s))if(e.entindex()==i)return e}function VS::FindEntityByString(s){local e,E=::Entities;while(e=E.Next(e))if(e.tostring()==s)return e}function VS::IsPointSized(h)return VectorIsZero(h.GetBoundingMaxs());function VS::FindEntityNearestFacing(O,D,T){local b=T,r,e,E=::Entities;while(e=E.Next(e)){if(IsPointSized(e))continue;local t=e.GetOrigin()-O;t.Norm();local d=D.Dot(t);if(d>b){b=d;r=e}}return r}function VS::FindEntityClassNearestFacing(O,D,T,C){local o=T,r,e,E=::Entities;while(e=E.FindByClassname(e,C)){local t=e.GetOrigin()-O;t.Norm();local d=D.Dot(t);if(d>o){o=d;r=e}}return r}function VS::FindEntityClassNearestFacingNearest(O,D,T,C,R){local r,e,E=::Entities;local x=R*R;if(!x)x=3.22122e+09;while(e=E.FindByClassname(e,C)){local t=e.GetOrigin()-O;t.Norm();local d=D.Dot(t);if(d>T){local s=(e.GetOrigin()-O).LengthSqr();if(x>s){r=e;x=s}}}return r}function VS::DrawEntityBBox(t,e,r=255,g=138,b=0,a=0)return::DebugDrawBox(e.GetOrigin(),e.GetBoundingMins(),e.GetBoundingMaxs(),r,g,b,a,t);function VS::FormatPrecision(f,n)return::format("%."+n+"f",f);function VS::FormatExp(i,n)return::format("%."+n+"e",i);function VS::FormatHex(i,n)return::format("%#0"+n+"x",i);function VS::FormatWidth(i,n,s=" ")return::format("%"+s+""+n+"s",i.tostring());::VecToString<-function(v,p="Vector(",s=",",x=")")return p+v.x+s+v.y+s+v.z+x;class::VS.TraceLine{constructor(S=null,E=null,H=null){if(!S){local v=::Vector();startpos=v;endpos=v;hIgnore=H;fraction=1.0;return};startpos=S;endpos=E;hIgnore=H;fraction=::TraceLine(startpos,endpos,hIgnore)}function DidHit()return fraction<1.0;function GetEnt(r=1.0)return GetEntByClassname("*",r);function GetEntByName(t,r=1.0){if(!hitpos)GetPos();return::Entities.FindByNameNearest(t,hitpos,r)}function GetEntByClassname(c,r=1.0){if(!hitpos)GetPos();return::Entities.FindByClassnameNearest(c,hitpos,r)}function GetPos(){if(!hitpos){if(DidHit())hitpos=startpos+(endpos-startpos)*fraction;else hitpos=endpos};return hitpos}function GetDist()return(startpos-GetPos()).Length();function GetDistSqr()return(startpos-GetPos()).LengthSqr();function GetNormal(){if(!normal){local u=::Vector(0.0,0.0,0.5),d=endpos-startpos;d.Norm();GetPos();normal=(hitpos-::VS.TraceDir(startpos+d.Cross(u),d).GetPos()).Cross(hitpos-::VS.TraceDir(startpos+u,d).GetPos());normal.Norm()};return normal}function _cmp(d){if(fraction<d.fraction)return-1;if(fraction>d.fraction)return 1;return 0}function _add(d)return fraction+d.fraction;function _sub(d)return fraction-d.fraction;function _mul(d)return fraction*d.fraction;function _div(d)return fraction/d.fraction;function _modulo(d)return fraction%d.fraction;function _unm()return-fraction;function _typeof()return"trace_t";startpos=null;endpos=null;hIgnore=null;fraction=0.0;hitpos=null;normal=null;m_Delta=null;m_IsSwept=null;m_Extents=null;m_IsRay=null;m_StartOffset=null;m_Start=null;function Ray(i=::Vector(),x=::Vector()){m_Delta=endpos-startpos;m_IsSwept=m_Delta.LengthSqr()!=0.0;m_Extents=(x-i)*0.5;m_IsRay=m_Extents.LengthSqr()<1.e-6;m_StartOffset=(i+x)*0.5;m_Start=startpos+m_StartOffset;m_StartOffset*=-1.0;return this}}function VS::TraceDir(v,d,f=::MAX_TRACE_LENGTH,h=null)return TraceLine(v,v+(d*f),h);function VS::UniqueString(){local s=::DoUniqueString("");return s.slice(0,s.len()-1)}function VS::arrayFind(a,V)foreach(i,v in a)if(v==V)return i;;function VS::arrayApply(a,f){foreach(i,v in a)a[i]=f(v)}function VS::arrayMap(a,f){local n=::array(a.len());foreach(i,v in a)n[i]=f(v);return n}function VS::DumpScope(T,A=false,P=true,G=true,D=0){local i=function(c)for(local i=0;i<c;++i)::print("   ");if(G)::print(" ------------------------------\n");if(T){foreach(K,V in T){local s=false;if(!A){foreach(k in slots_default)if(K==k)s=true}else if(K=="VS"||K=="Documentation")s=true;;if(!s){i(D);::print(K);switch(typeof V){case"table": ::print("(TABLE) : "+V.len());if(!P)break;::print("\n");i(D);::print("{\n");DumpScope(V,A,P,false,D+1);i(D);::print("}");break;case"array": ::print("(ARRAY) : "+V.len());if(!P)break;::print("\n");i(D);::print("[\n");DumpScope(V,A,P,false,D+1);i(D);::print("]");break;case"string": ::print(" = \""+V+"\"");break;case"Vector": ::print(" = "+::VecToString(V));break;default: ::print(" = "+V)}::print("\n")}}}else::print("null\n");if(G)::print(" ------------------------------\n")}function VS::ArrayToTable(a){local t={}foreach(i,v in a)t[v]<-i;return t}function VS::GetStackInfo(P=false,A=false){::print(" --- STACKINFO ----------------\n");local s,j=2;while(s=::getstackinfos(j++)){if(s.func=="pcall"&&s.src=="NATIVE")break;::print(" ("+(j-1)+")\n");local w,m=s.locals;if("this"in m&&typeof m["this"]=="table"){if(m["this"]==::getroottable()){w="roottable"}else{w=GetVarName(m["this"]);m[w]<-delete m["this"]}};if(w=="roottable")DumpScope(s,A,0,0);else DumpScope(s,A,P,0);if(w)::print("scope = \""+w+"\"\n")}::print(" --- STACKINFO ----------------\n")}VS.GetCaller<-::compilestring("return(getstackinfos(3)[\"locals\"][\"this\"])");VS.GetCallerFunc<-::compilestring("return(getstackinfos(3)[\"func\"])");function VS::GetTableDir(T){if(typeof T!="table")throw"Invalid input type '"+typeof T+"' ; expected: 'table'";local r=_f627f40d21a6([],T);if(r)r.append("roottable");else r=["roottable"];r.reverse();return r}function VS::_f627f40d21a6(bF,t,l=::getroottable()){foreach(v,u in l)if(typeof u=="table")if(v!="VS"&&v!="Documentation")if(u==t){bF.append(v);return bF}else{local r=_f627f40d21a6(bF,t,u);if(r){bF.append(v);return r}}}function VS::FindVarByName(S){if(typeof S!="string")throw"Invalid input type '"+typeof S+"' ; expected: 'string'";return _fb3k55Ir91t7(S)}function VS::_fb3k55Ir91t7(t,l=::getroottable()){if(t in l)return l[t];else foreach(v,u in l)if(typeof u=="table")if(v!="VS"&&v!="Documentation"){local r=_fb3k55Ir91t7(t,u);if(r)return r}}function VS::GetVarName(v){local t=typeof v;if(t=="function"||t=="native function")return v.getinfos().name;return _fb3k5S1r91t7(t,v)}function VS::_fb3k5S1r91t7(t,i,s=::getroottable()){foreach(k,v in s){if(v==i)return k;if(typeof v=="table")if(k!="VS"&&k!="Documentation"){local r=_fb3k5S1r91t7(t,i,v);if(r)return r}}}function VS::GetTickrate()return 1.0/::FrameTime();_v0();::delay<-function(X,T=0.0,E=::ENT_SCRIPT,A=null,C=null)return::DoEntFireByInstanceHandle(E,"runscriptcode",""+X,T,A,C);::Chat<-function(s)return::ScriptPrintMessageChatAll(" "+s);::ChatTeam<-function(i,s)return::ScriptPrintMessageChatTeam(i," "+s);::Alert<-::ScriptPrintMessageCenterAll;::AlertTeam<-::ScriptPrintMessageCenterTeam;::ClearChat<-function()for(local i=0;i<9;++i)::Chat("");function VS::GetPlayerByUserid(i){local e,E=::Entities;while(e=E.Next(e))if(e.GetClassname()=="player"){local s=e.GetScriptScope();if("userid"in s&&s.userid==i)return e}}function VS::Events::player_connect(D){if(::_xa9b2dfB7ffe.len()>128){for(local i=0;i<64;++i)::_xa9b2dfB7ffe.remove(0);::print("player_connect: ERROR!!! Player data is not being processed\n")};::_xa9b2dfB7ffe.append(D);return::OnGameEvent_player_connect(D)}function VS::Events::player_spawn(D){if(::_xa9b2dfB7ffe.len())foreach(i,d in::_xa9b2dfB7ffe)if(d.userid==D.userid){local p=::VS.GetPlayerByIndex(d.index+1);if(!p.ValidateScriptScope()){::print("player_connect: Invalid player entity\n");break};local s=p.GetScriptScope();if("networkid"in s){::print("player_connect: BUG!!! Something has gone wrong. ");if(s.networkid==d.networkid){::print("Duplicated data!\n");::_xa9b2dfB7ffe.remove(i)}else::print("Conflicting data!\n");break};if(!d.networkid.len())::print("player_connect: could not get event data\n");s.userid<-d.userid;s.name<-d.name;s.networkid<-d.networkid;::_xa9b2dfB7ffe.remove(i);break};;return::OnGameEvent_player_spawn(D)}function VS::Events::ForceValidateUserid(E){if(!E||!E.IsValid()||E.GetClassname()!="player")return::print("ForceValidateUserid: Invalid input: "+E+"\n");if(!::Entc("logic_eventlistener"))return::print("ForceValidateUserid: No eventlistener found\n");local proxy;if(!(proxy=::VS.FindEntityByIndex(iProxyIdx))){proxy=::VS.CreateEntity("info_game_event_proxy",{event_name="player_info"},true);iProxyIdx=proxy.entindex()};E.ValidateScriptScope();_SV=E.GetScriptScope();::EntFireByHandle(proxy,"generategameevent","",0,E)}function VS::Events::player_info(data){if(_SV){_SV.userid<-data.userid;if(!("name"in _SV))_SV.name<-"";if(!("networkid"in _SV))_SV.networkid<-"";_SV=null};if(!("OnGameEvent_player_info"in::getroottable()))::OnGameEvent_player_info<-::dummy;return::OnGameEvent_player_info(data)}::VS.Events._SV<-null;::VS.Events.iProxyIdx<-null;function VS::Log::_Print(f){local t=filter,p=::print;if(!f)for(local i=nC;i<nN;++i)p(L[i]);else for(local i=nC;i<nN;++i)p(t+L[i]);;nC+=nD;nN=::clamp(nN+nD,0,nL);if(nC>=nN){if(f)_Stop();nL=null;nD=null;nC=null;nN=null;return};return::delay("::VS.Log._Print("+f+")",::FrameTime())}function VS::Log::_Start(){nL<-L.len();nD<-2000;nC<-0;nN<-::clamp(nD,0,nL);if(export){local f=filePrefix[0]==58?filePrefix.slice(1):filePrefix+"_"+::VS.UniqueString();_d<-::developer();::SendToConsole("developer 0;con_filter_enable 1;con_filter_text_out\""+filter+"\";con_filter_text\"\";con_logfile\""+f+".log\";script delay(\"::VS.Log._Print(1)\","+::FrameTime()*4.0+")");return f}else _Print(0)}function VS::Log::_Stop()::SendToConsole("con_logfile\"\";con_filter_text_out\"\";con_filter_text\"\";con_filter_enable 0;developer "+_d);function VS::Log::Run(){if(!condition)return;return _Start()}function VS::Log::Add(s)L.append(s);function VS::Log::Clear()L.clear();
