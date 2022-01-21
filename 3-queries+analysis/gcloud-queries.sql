-- $ gcloud sql connect fb-schools --user=postgres
-- $ enter password

-- Overview on tables
-- SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';

-- Overview on columns
-- select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='posts';

-- Head
-- SELECT url FROM posts LIMIT 10;

-- Get posts by value
-- SELECT url, wow FROM posts WHERE wow >= 1 LIMIT 5;

-- Single URL lookup
SELECT * FROM posts WHERE url = 'https://www.facebook.com/HotSpringsHuskies/posts/902905996776728';

-- Left join school data
SELECT posts.*, profile_lookup.*, nces_schools.* FROM posts 
LEFT JOIN profile_lookup ON profile_lookup.profile_id = posts.profile_id
LEFT JOIN nces_schools ON nces_schools.schoolncesid = profile_lookup.nces_id
LIMIT 3;

-- Left join district data
SELECT posts.*, profile_lookup.*, nces_districts.* FROM posts 
LEFT JOIN profile_lookup ON profile_lookup.profile_id = posts.profile_id
LEFT JOIN nces_districts ON nces_districts.districtncesid = profile_lookup.nces_id
LIMIT 3;

-- Left join of with filtering
SELECT posts.*, profile_lookup.*, nces_schools.* FROM posts 
LEFT JOIN profile_lookup ON profile_lookup.profile_id = posts.profile_id
LEFT JOIN nces_schools ON nces_schools.schoolncesid = profile_lookup.nces_id
WHERE wow > 1
LIMIT 3;

-- Get 100 sampled posts by URL including NCES school data

SELECT posts.*, profile_lookup.*, nces_schools.* FROM posts 
LEFT JOIN profile_lookup ON profile_lookup.profile_id = posts.profile_id
LEFT JOIN nces_schools ON nces_schools.schoolncesid = profile_lookup.nces_id
WHERE URL IN (
    'https://www.facebook.com/HotSpringsHuskies/posts/902905996776728',
    'https://www.facebook.com/JfkElementary/posts/1478065202333570',
    'https://www.facebook.com/ErieMiddleSchool/posts/1413047238844885',
    'https://www.facebook.com/SchoolDistrict7/posts/3432311576786522',
    'https://www.facebook.com/ISSchoolDist/posts/2450864934968700',
    'https://www.facebook.com/CarthageISDTX/posts/2678893752186697',
    'https://www.facebook.com/eolahillscharterschool/posts/2666633590086978',
    'https://www.facebook.com/VincentFarmElementaryPTA/posts/2847406621938870',
    'https://www.facebook.com/SanAugustineChamber/posts/2428698170562431',
    'https://www.facebook.com/FayetteCountyPublicSchools/posts/10156849988882817',
    'https://www.facebook.com/westearlycollege/posts/1854564701298199',
    'https://www.facebook.com/RoanokeCitySchools/posts/557989417989833',
    'https://www.facebook.com/1653097924943309/posts/2105878232998607',
    'https://www.facebook.com/glcpschool/posts/1868717243174024',
    'https://www.facebook.com/259590337410631/posts/1869049386464710',
    'https://www.facebook.com/SanAntonioISD/posts/10157747881206102',
    'https://www.facebook.com/stantonschools/posts/2207506682624017',
    'https://www.facebook.com/MexicoMiddleSchool/posts/2290203117869225',
    'https://www.facebook.com/GroveCitySD/posts/530399217399900',
    'https://www.facebook.com/GISDPage/posts/2189512461119284',
    'https://www.facebook.com/WaukeganPublicSchools/posts/1588818214503302',
    'https://www.facebook.com/scceducation/posts/1365654003510295',
    'https://www.facebook.com/spencertigers/posts/1539032922785619',
    'https://www.facebook.com/180358508765847/posts/1069141399887549',
    'https://www.facebook.com/NorthRidgevilleCitySchools/posts/1191108554332219',
    'https://www.facebook.com/mountain.mahogany/posts/1056757497757306',
    'https://www.facebook.com/southerndoorschools/posts/797277587105499',
    'https://www.facebook.com/NKCSchools/posts/10155386044277059',
    'https://www.facebook.com/ChatfieldPublicSchools/posts/1515927528439004',
    'https://www.facebook.com/SpringdaleSchools/posts/10155115640467931',
    'https://www.facebook.com/southredford/posts/1626359794158517',
    'https://www.facebook.com/TimberlaneHS/posts/1864165726972406',
    'https://www.facebook.com/HattiesburgPSD/posts/2175838879125491',
    'https://www.facebook.com/nssd112/posts/2013087782071520',
    'https://www.facebook.com/DavisonInvent/posts/2575395622485844',
    'https://www.facebook.com/WildcatsE04/posts/510775252679552',
    'https://www.facebook.com/LincolnElemSchool/posts/1872420913065379',
    'https://www.facebook.com/willowmagnetschool/posts/241107523184537',
    'https://www.facebook.com/EVSD90/posts/646376492398013',
    'https://www.facebook.com/isd742.org/posts/808672605923207',
    'https://www.facebook.com/daviddouglasschooldistrict/posts/10157527483305335',
    'https://www.facebook.com/725886810849730/posts/943705635734512',
    'https://www.facebook.com/DublinSchools/posts/1159491127454934',
    'https://www.facebook.com/YsletaISD/posts/10153733824992811',
    'https://www.facebook.com/bps101/posts/1043862925712176',
    'https://www.facebook.com/LowndesMiddleVikings/posts/1777442952513218',
    'https://www.facebook.com/258403747526640/posts/1332669190100085',
    'https://www.facebook.com/EagleRockHighSchool/posts/1413107978702844',
    'https://www.facebook.com/AntigoSchool/posts/1433999333282202',
    'https://www.facebook.com/MMBDAPCS/posts/1252063831480702',
    'https://www.facebook.com/yram.township.school.district/posts/1155844711092992',
    'https://www.facebook.com/flemrarschools/posts/862818237160027',
    'https://www.facebook.com/CullinsElementary/posts/767921389979421',
    'https://www.facebook.com/WHHSFoundation/posts/1323395901020840',
    'https://www.facebook.com/newwaverlyffa/posts/1119012114783955',
    'https://www.facebook.com/353419704742835/posts/975880245830108',
    'https://www.facebook.com/FMSNM/posts/680103482092187',
    'https://www.facebook.com/JTHS204/posts/10153316244346366',
    'https://www.facebook.com/laredoisd/posts/963526000405197',
    'https://www.facebook.com/AmerySchools/posts/969028396509225',
    'https://www.facebook.com/oconomowocschools/posts/3162912260388257',
    'https://www.facebook.com/WestfieldMAPublicSchools/posts/3182608648451112',
    'https://www.facebook.com/NWR7highlander/posts/1569260609898271',
    'https://www.facebook.com/toledoschooldistrict/posts/2528344584085981',
    'https://www.facebook.com/164120433722584/posts/1964725403662069',
    'https://www.facebook.com/redbankelem/posts/1202988340047569',
    'https://www.facebook.com/916436025129866/posts/2883761401730642',
    'https://www.facebook.com/PTHSD209/posts/1656755434478034',
    'https://www.facebook.com/LaMonteSchool/posts/1932239883576189',
    'https://www.facebook.com/columbuscharterschool/posts/10154671523102259',
    'https://www.facebook.com/IbervilleSchools/posts/1731782370407860',
    'https://www.facebook.com/springhillusd230/posts/1186674548040617',
    'https://www.facebook.com/ParkVistaCommunityHighSchool/posts/783162595120542',
    'https://www.facebook.com/clevemetrosd/posts/10154523897502774',
    'https://www.facebook.com/kauffmanschool/posts/1151590984887014',
    'https://www.facebook.com/FourCornersMontessori/posts/10153936105685748',
    'https://www.facebook.com/359325234161853/posts/1103392233088479',
    'https://www.facebook.com/217421078316373/posts/1162659987125806',
    'https://www.facebook.com/summithill161/posts/799757026832739',
    'https://www.facebook.com/Osceola.Middle.Okeechobee/posts/467470900020922',
    'https://www.facebook.com/424140317622854/posts/620330564670494',
    'https://www.facebook.com/pcsd68048/posts/10152157523375279',
    'https://www.facebook.com/AthensISD/posts/764653123566469',
    'https://www.facebook.com/BrickerES/posts/3007862118059',
    'https://www.facebook.com/PTISDPirates/posts/572766746143364',
    'https://www.facebook.com/GranvilleExemptedVillageSchools/posts/274076159415647',
    'https://www.facebook.com/nhsreds/posts/607931585926624',
    'https://www.facebook.com/MarinaHighSchool/posts/10151959711736448',
    'https://www.facebook.com/AthensISD/posts/764634623568319',
    'https://www.facebook.com/inglesideisd/posts/2380785548683006',
    'https://www.facebook.com/fredericschooldistrict/posts/2526979224020424',
    'https://www.facebook.com/NewburghSchools/posts/2540828725973858',
    'https://www.facebook.com/MOEducation/posts/2475325739199183',
    'https://www.facebook.com/CenterPointElementary/posts/1574979979302893',
    'https://www.facebook.com/WABessElementary/posts/2847345025337337',
    'https://www.facebook.com/281888349894/posts/10156667760949895',
    'https://www.facebook.com/KHSPanthers/posts/962718097257133',
    'https://www.facebook.com/167364959965666/posts/2301841416517999',
    'https://www.facebook.com/daytonpublicschools/posts/2908296425852151',
    'https://www.facebook.com/198782330457969/posts/1125732101096316'
);

-- Get 100 sampled posts by URL including NCES district data

SELECT posts.*, profile_lookup.*, nces_districts.* FROM posts 
LEFT JOIN profile_lookup ON profile_lookup.profile_id = posts.profile_id
LEFT JOIN nces_districts ON nces_districts.districtncesid = profile_lookup.nces_id
WHERE URL IN (
    'https://www.facebook.com/HotSpringsHuskies/posts/902905996776728',
    'https://www.facebook.com/JfkElementary/posts/1478065202333570',
    'https://www.facebook.com/ErieMiddleSchool/posts/1413047238844885',
    'https://www.facebook.com/SchoolDistrict7/posts/3432311576786522',
    'https://www.facebook.com/ISSchoolDist/posts/2450864934968700',
    'https://www.facebook.com/CarthageISDTX/posts/2678893752186697',
    'https://www.facebook.com/eolahillscharterschool/posts/2666633590086978',
    'https://www.facebook.com/VincentFarmElementaryPTA/posts/2847406621938870',
    'https://www.facebook.com/SanAugustineChamber/posts/2428698170562431',
    'https://www.facebook.com/FayetteCountyPublicSchools/posts/10156849988882817',
    'https://www.facebook.com/westearlycollege/posts/1854564701298199',
    'https://www.facebook.com/RoanokeCitySchools/posts/557989417989833',
    'https://www.facebook.com/1653097924943309/posts/2105878232998607',
    'https://www.facebook.com/glcpschool/posts/1868717243174024',
    'https://www.facebook.com/259590337410631/posts/1869049386464710',
    'https://www.facebook.com/SanAntonioISD/posts/10157747881206102',
    'https://www.facebook.com/stantonschools/posts/2207506682624017',
    'https://www.facebook.com/MexicoMiddleSchool/posts/2290203117869225',
    'https://www.facebook.com/GroveCitySD/posts/530399217399900',
    'https://www.facebook.com/GISDPage/posts/2189512461119284',
    'https://www.facebook.com/WaukeganPublicSchools/posts/1588818214503302',
    'https://www.facebook.com/scceducation/posts/1365654003510295',
    'https://www.facebook.com/spencertigers/posts/1539032922785619',
    'https://www.facebook.com/180358508765847/posts/1069141399887549',
    'https://www.facebook.com/NorthRidgevilleCitySchools/posts/1191108554332219',
    'https://www.facebook.com/mountain.mahogany/posts/1056757497757306',
    'https://www.facebook.com/southerndoorschools/posts/797277587105499',
    'https://www.facebook.com/NKCSchools/posts/10155386044277059',
    'https://www.facebook.com/ChatfieldPublicSchools/posts/1515927528439004',
    'https://www.facebook.com/SpringdaleSchools/posts/10155115640467931',
    'https://www.facebook.com/southredford/posts/1626359794158517',
    'https://www.facebook.com/TimberlaneHS/posts/1864165726972406',
    'https://www.facebook.com/HattiesburgPSD/posts/2175838879125491',
    'https://www.facebook.com/nssd112/posts/2013087782071520',
    'https://www.facebook.com/DavisonInvent/posts/2575395622485844',
    'https://www.facebook.com/WildcatsE04/posts/510775252679552',
    'https://www.facebook.com/LincolnElemSchool/posts/1872420913065379',
    'https://www.facebook.com/willowmagnetschool/posts/241107523184537',
    'https://www.facebook.com/EVSD90/posts/646376492398013',
    'https://www.facebook.com/isd742.org/posts/808672605923207',
    'https://www.facebook.com/daviddouglasschooldistrict/posts/10157527483305335',
    'https://www.facebook.com/725886810849730/posts/943705635734512',
    'https://www.facebook.com/DublinSchools/posts/1159491127454934',
    'https://www.facebook.com/YsletaISD/posts/10153733824992811',
    'https://www.facebook.com/bps101/posts/1043862925712176',
    'https://www.facebook.com/LowndesMiddleVikings/posts/1777442952513218',
    'https://www.facebook.com/258403747526640/posts/1332669190100085',
    'https://www.facebook.com/EagleRockHighSchool/posts/1413107978702844',
    'https://www.facebook.com/AntigoSchool/posts/1433999333282202',
    'https://www.facebook.com/MMBDAPCS/posts/1252063831480702',
    'https://www.facebook.com/yram.township.school.district/posts/1155844711092992',
    'https://www.facebook.com/flemrarschools/posts/862818237160027',
    'https://www.facebook.com/CullinsElementary/posts/767921389979421',
    'https://www.facebook.com/WHHSFoundation/posts/1323395901020840',
    'https://www.facebook.com/newwaverlyffa/posts/1119012114783955',
    'https://www.facebook.com/353419704742835/posts/975880245830108',
    'https://www.facebook.com/FMSNM/posts/680103482092187',
    'https://www.facebook.com/JTHS204/posts/10153316244346366',
    'https://www.facebook.com/laredoisd/posts/963526000405197',
    'https://www.facebook.com/AmerySchools/posts/969028396509225',
    'https://www.facebook.com/oconomowocschools/posts/3162912260388257',
    'https://www.facebook.com/WestfieldMAPublicSchools/posts/3182608648451112',
    'https://www.facebook.com/NWR7highlander/posts/1569260609898271',
    'https://www.facebook.com/toledoschooldistrict/posts/2528344584085981',
    'https://www.facebook.com/164120433722584/posts/1964725403662069',
    'https://www.facebook.com/redbankelem/posts/1202988340047569',
    'https://www.facebook.com/916436025129866/posts/2883761401730642',
    'https://www.facebook.com/PTHSD209/posts/1656755434478034',
    'https://www.facebook.com/LaMonteSchool/posts/1932239883576189',
    'https://www.facebook.com/columbuscharterschool/posts/10154671523102259',
    'https://www.facebook.com/IbervilleSchools/posts/1731782370407860',
    'https://www.facebook.com/springhillusd230/posts/1186674548040617',
    'https://www.facebook.com/ParkVistaCommunityHighSchool/posts/783162595120542',
    'https://www.facebook.com/clevemetrosd/posts/10154523897502774',
    'https://www.facebook.com/kauffmanschool/posts/1151590984887014',
    'https://www.facebook.com/FourCornersMontessori/posts/10153936105685748',
    'https://www.facebook.com/359325234161853/posts/1103392233088479',
    'https://www.facebook.com/217421078316373/posts/1162659987125806',
    'https://www.facebook.com/summithill161/posts/799757026832739',
    'https://www.facebook.com/Osceola.Middle.Okeechobee/posts/467470900020922',
    'https://www.facebook.com/424140317622854/posts/620330564670494',
    'https://www.facebook.com/pcsd68048/posts/10152157523375279',
    'https://www.facebook.com/AthensISD/posts/764653123566469',
    'https://www.facebook.com/BrickerES/posts/3007862118059',
    'https://www.facebook.com/PTISDPirates/posts/572766746143364',
    'https://www.facebook.com/GranvilleExemptedVillageSchools/posts/274076159415647',
    'https://www.facebook.com/nhsreds/posts/607931585926624',
    'https://www.facebook.com/MarinaHighSchool/posts/10151959711736448',
    'https://www.facebook.com/AthensISD/posts/764634623568319',
    'https://www.facebook.com/inglesideisd/posts/2380785548683006',
    'https://www.facebook.com/fredericschooldistrict/posts/2526979224020424',
    'https://www.facebook.com/NewburghSchools/posts/2540828725973858',
    'https://www.facebook.com/MOEducation/posts/2475325739199183',
    'https://www.facebook.com/CenterPointElementary/posts/1574979979302893',
    'https://www.facebook.com/WABessElementary/posts/2847345025337337',
    'https://www.facebook.com/281888349894/posts/10156667760949895',
    'https://www.facebook.com/KHSPanthers/posts/962718097257133',
    'https://www.facebook.com/167364959965666/posts/2301841416517999',
    'https://www.facebook.com/daytonpublicschools/posts/2908296425852151',
    'https://www.facebook.com/198782330457969/posts/1125732101096316'
);


-- Descriptive statistics by whole sample

-- Sample Request Counting States

SELECT nces_schools.statecode, COUNT(nces_schools.statecode) FROM posts
LEFT JOIN profile_lookup ON profile_lookup.profile_id = posts.profile_id
LEFT JOIN nces_schools ON nces_schools.schoolncesid = profile_lookup.nces_id
GROUP BY nces_schools.statecode;

-- You can also do mean, median, mode, range, ...
-- https://www.jeannicholashould.com/descriptive-statistics-in-sql.html

-- TODO: FILTER SCHOOLS IN NCES DATA SETS THAT APPEAR `posts`
-- TODO: Compare districts through `GROUP BY`?

-- SCHOOL VARIABLES TO LOOK AT
--stateabbrlatest
--statecode
--freereducedlunch
--lunchprogram
--lowestofferedgrade
--highestofferedgrade
--schoollevel
--agencytype
--urbancentric

-- DISTRICT VARIABLES TO LOOK AT
--state
--agencytype
--urbancentric
--g12thoffered
--g11thoffered
--g10thoffered
--g9thoffered
--g8thoffered
--g7thoffered
--g6thoffered
--g5thoffered
--g4thoffered
--g3rdoffered
--g2ndoffered
--g1stoffered
--gkoffered
--prekoffered
--highestofferedgrade
--freereducedlunch
--pupilteacherratio
