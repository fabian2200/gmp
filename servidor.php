<?php

use Dotenv\Dotenv; 
use Illuminate\Foundation\Bootstrap\LoadConfiguration;

/*
  |--------------------------------------------------------------------------
  | Web Routes
  |--------------------------------------------------------------------------
  |
  | Here is where you can register web routes for your application. These
  | routes are loaded by the RouteServiceProvider within a group which
  | contains the "web" middleware group. Now create something great!
  |
 */

Route::get('/guardartoken', function () {
    header("Access-Control-Allow-Origin: *");
    $value = "bd_gmp2";
	
    //$companias = \App\companias::todas();
    $companias = DB::connection("mysql")->table($value . ".users")
           ->where("id",request()->get("id"))
		   ->update([
			   'token_fcm' => request()->get("token")
		   ]);
           //->where("id_usu",request()->get("id_usu"))
    return response()->json([
              'token' =>  request()->get("token")
    ]);
});

Route::get('/', function () {
    $path = base_path('.env');


    if (is_bool(env("DB_DATABASE"))) {
        $old = env("DB_DATABASE") ? 'true' : 'false';
    } elseif (env("DB_DATABASE") === null) {
        $old = 'null';
    } else {
        $old = env("DB_DATABASE");
    }

    dd($old);
    die;
});

Route::get('/login', function () {
    header("Access-Control-Allow-Origin: *");

    $value = "bd_gmp2";
	
    $logueo = false;
    $usuario = false;
    $data = request()->all();
    $usuario = \App\users::login($data['email'], "");
    if ($usuario && \Hash::check($data['password'], $usuario->pasword)) {
        auth()->loginUsingId($usuario->id);
        $logueo = true;
    } else {
        $logueo = false;
        $usuario = false;
    }
    return response()->json([
                'usuario' => $usuario,
                'logueo' => $logueo
    ]);
});

Route::get('/validarnombrecompania', function () {
    header("Access-Control-Allow-Origin: *");
    $value = "bd_gmp2";
	
    //$companias = \App\companias::todas();
    $companias = DB::connection("mysql")->table($value . ".companias")
		   ->leftJoin($value.".ubic_def_compa","ubic_def_compa.compa_ubi","companias.companias_login")
           ->where("companias_estado","ACTIVA")
           ->where("companias_muni",request()->get("nombre"))
           ->first();
    return response()->json([
                'companias' => $companias,
    ]);
});

Route::get('/validarnombrecompania2', function () {
    header("Access-Control-Allow-Origin: *");
    $value = "bd_gmp2";
    $nombre = request()->get("nombre");
	
    //$companias = \App\companias::todas();
    $companias = DB::connection("mysql")->select("SELECT c.companias_id, c.companias_login, c.companias_descripcion, uc.lat_ubic, uc.long_ubi FROM ".$value . ".companias c INNER JOIN ".$value . ".ubic_def_compa uc on c.companias_login = uc.compa_ubi WHERE c.companias_estado = 'ACTIVA' AND c.companias_muni = '".$nombre."'");
    return response()->json([
                'companias' => $companias,
    ]);
});

Route::get('/companias', function () {
    header("Access-Control-Allow-Origin: *");
    $value = "bd_gmp2";
	
    //$companias = \App\companias::todas();
    $companias = DB::connection("mysql")->table($value . ".companias")
		   ->leftJoin($value.".ubic_def_compa","ubic_def_compa.compa_ubi","companias.companias_login")
           ->where("companias_estado","ACTIVA")
           //->where("id_usu",request()->get("id_usu"))
           ->get();
    return response()->json([
                'companias' => $companias,
    ]);
});

Route::get('/companias1', function () {
    header("Access-Control-Allow-Origin: *");
    $value = "bd_gmp2";
	
    //$companias = \App\companias::todas();
    $companias = DB::connection("mysql")->select("select companias_id, companias_descripcion from " . $value . ".companias");
    $companias2 = DB::connection("mysql")->select("select 0 as companias_id, 'Seleccione una entidad...' as companias_descripcion");
    
    $companias = array_merge($companias2,$companias);

    return response()->json([
                'companias' => $companias,
    ]);
});

Route::get('/secretarias', function () {
    header("Access-Control-Allow-Origin: *");
    //$secretarias = new App\secretarias("Valor");
    //$secretarias->table = request()->get("bd").".".$secretarias->table;
   
    $value = request()->get("bd");
    
    $secretarias = DB::connection("mysql")->select("select * from " . $value . ".secretarias");
    
    //dd(env("DB_DATABASE"));die;

    //$secretaria = App\secretarias::todas();
    return response()->json([
                'secretarias' => $secretarias,
    ]);
    
});

Route::get('/secretariasl', function () {
    header("Access-Control-Allow-Origin: *");
    //$secretarias = new App\secretarias("Valor");
    //$secretarias->table = request()->get("bd").".".$secretarias->table;
   
    $value = request()->get("bd");
	
	$secretarias1 = DB::connection("mysql")->select("select idsecretarias,des_secretarias from " . $value . ".secretarias");
	
	$secretarias = DB::connection("mysql")->select("select 0 as idsecretarias,'TODAS' as des_secretarias ");
	
	$secretarias = array_merge($secretarias,$secretarias1);
	
	//dd($secretarias);die;
    
    
	
	
    
    //dd(env("DB_DATABASE"));die;

    //$secretaria = App\secretarias::todas();
    return response()->json([
                'secretarias' => $secretarias,
    ]);
    
});

Route::get('/nombre_secretaria', function () {
	header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
	$iddpto = request()->get("dep");
	$idmuni = request()->get("muni");
	$idcorre = request()->get("cor");
    $value = request()->get("bd");
	
	$secretaria = DB::connection("mysql")->table($value . ".secretarias")->select("des_secretarias")->where("idsecretarias",$id)->first();
	
	$dpto = DB::connection("mysql")->table("dpto")->select("NOM_DPTO")->where("COD_DPTO",$iddpto)->first();
	
	$muni = DB::connection("mysql")->table("muni")->select("NOM_MUNI")->where("COD_MUNI",$idmuni)->first();
	
	$corre = DB::connection("mysql")->table("corregi")->select("NOM_CORREGI")->where("ID_CORREGI",$idcorre)->first();
	
	return response()->json([
                'secretaria' => $secretaria,
                'muni' => $muni,
				'dpto' => $dpto,
				'corre' => $corre
    ]);
	
});

Route::get('/secretaria', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
    
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    $temp = DB::connection("mysql")->table($value . ".secretarias")
		    ->leftJoin($value .".presupuesto_secretarias","presupuesto_secretarias.id_secretaria","secretarias.idsecretarias")
->select("secretarias.*","presupuesto_secretarias.valor")
		->where("idsecretarias",$id)->first();
    //$dptos = DB::table($value . ".dpto")
    //        ->get();
	
	$secretaria = DB::connection("mysql")
           ->select("SELECT
                    s.des_secretarias,SUM(IF(g.vfin_contrato > 0,
                   g.vfin_contrato,
                   g.vcontr_contrato)) AS TOTAL_PROYECTOS,
               SUM(g.veje_contrato) AS TOTAL_EJECUCION_PROYECTOS
           FROM
               (SELECT
                   MAX(id_contrato) AS id_con,
                       vfin_contrato AS vfin,
                       num_contrato AS num,
                       vcontr_contrato AS vcon
               FROM
                ".$value.".contratos
               WHERE
                   estcont_contra = 'Verificado'
               GROUP BY num_contrato) AS cons
                   INNER JOIN
               ".$value.".contratos g ON cons.num = g.num_contrato
                   INNER JOIN
               ".$value.".proyectos p ON p.id_proyect = g.idproy_contrato
                    INNER JOIN
                    ".$value.".secretarias s ON p.secretaria_proyect = s.idsecretarias
           WHERE
               g.id_contrato = cons.id_con
                   AND p.estado = 'ACTIVO'
                    AND s.idsecretarias = '".$id."'
                    AND estado_secretaria='ACTIVO'
                    GROUP BY s.idsecretarias");
	
	$proyectos = DB::connection("mysql")->table($value . ".proyectos")
			->select("estado_proyect")
			->groupBy("estado_proyect")
			->selectRaw("count(*) as cont")
			->where($value . ".proyectos.secretaria_proyect",$temp->idsecretarias)
			->orderBy("estado_proyect","asc")
			->get();
	
	foreach($proyectos as $pro){
		$pro->proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.secretaria_proyect",$temp->idsecretarias)
			->where($value . ".proyectos.estado_proyect",$pro->estado_proyect)
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();
	}
	
   /* $proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.secretaria_proyect",$secretaria->idsecretarias)
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();*/
	
	$dptos = DB::connection("mysql")->table($value . ".dpto")
		->get();
    
    return response()->json([
                'secretaria' => $secretaria,
                'proyectos' => $proyectos,
				'dptos' => $dptos,
				'valor' => $temp->valor
    ]);
});

Route::get('/departamentos', function () {
	header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	/*$dptos = DB::connection("mysql")->table($value . ".dpto")
		->select("cod_dpto")
		->get();*/
	
	$dptos1 = DB::connection("mysql")->select("select COD_DPTO,NOM_DPTO from " . $value . ".dpto");
	
	$dptos = DB::connection("mysql")->select("select 0 as COD_DPTO,'TODOS' as NOM_DPTO ");
	
	$dptos = array_merge($dptos,$dptos1);
    
    return response()->json([
				'dptos' => $dptos
    ]);
});

Route::get('/lsecretaria', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    $secretarias = DB::connection("mysql")->select("select * from " . $value . ".secretarias");
    //$dptos = DB::table($value . ".dpto")
    //        ->get();
    /*$proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->join($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.secretaria_proyect",$secretaria->idsecretarias)
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();*/
	
	$dptos = DB::connection("mysql")->table($value . ".dpto")
		->get();
    
    return response()->json([
                'secretaria' => $secretarias,
                //'proyectos' => $proyectos,
				'dptos' => $dptos
    ]);
});

Route::get('/municipios', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
    
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    //$secretaria = DB::connection("mysql")->table($value . ".muni")->where("ID_DPTO",$id)->get(); 
	$muni1 = DB::connection("mysql")->select("select COD_MUNI,NOM_MUNI from " . $value . ".muni where ID_DPTO='".$id."'");
	
	$muni = DB::connection("mysql")->select("select 0 as COD_MUNI,'TODOS' as NOM_MUNI");
	
	$muni = array_merge($muni,$muni1);
    
    return response()->json([
                'muni' => $muni,
				'id' => $id
    ]);
});

Route::get('/corregimientos', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    //$corregimientos = DB::connection("mysql")->table($value . ".corregi")->where("ID_MUNI",$id)->get();  
	
	$corregimientos1 = DB::connection("mysql")->select("select ID_CORREGI,NOM_CORREGI from " . $value . ".corregi where ID_MUNI='".$id."'");
	
	$corregimientos = DB::connection("mysql")->select("select 0 as ID_CORREGI,'TODOS' as NOM_CORREGI");
	
	$corregimientos = array_merge($corregimientos,$corregimientos1);
    
    return response()->json([
                'corregimientos' => $corregimientos,
    ]);
});

Route::get('/geomarkers', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$data = request()->all();
    
    $consulta = "1 ";
    
    if(request()->get("dep") != "undefined" && request()->get("dep") != "" && request()->get("dep") != "0"){
        $consulta .= " AND depar_ubic = '".request()->get("dep")."'";
    }
    
    if(request()->get("mun") != "undefined" && request()->get("mun") != "" && request()->get("mun") != "0"){
        $consulta .= " AND muni_ubic = '".request()->get("mun")."'";
    }
    
    if(request()->get("cor") != "undefined" && request()->get("cor") != "" && request()->get("cor") != "0"){
        $consulta .= " AND corr_ubic = '".request()->get("cor")."'";
    }
	
    //print_r($data['mun']);die;
	
	if(request()->get("id") != "undefined" && request()->get("id") != "null" && request()->get("id") != '' && request()->get("id") != '0' ){
		
        $consulta .= " AND proyectos.secretaria_proyect = '".request()->get("id")."'";
    }
	
	$consulta .= " AND (proyectos.estado_proyect = 'Ejecutado' || proyectos.estado_proyect = 'En Ejecucion') ";
	
    $proyectos = DB::connection("mysql")->table($value . ".ubic_proyect")
            ->join($value . ".proyectos",$value . ".ubic_proyect.proyect_ubi",$value . ".proyectos.id_proyect")
            ->whereRaw($consulta)
            //->where($value . ".proyectos.secretaria_proyect",request()->get("id"))
            ->get();  
    
    return response()->json([
                'proyectos' => $proyectos,
				'cantidad' => count($proyectos)
    ]);
});

Route::get('/geomarkerstexto', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
    
    $consulta = "1 ";
    
    if(request()->get("dep") != "undefined" && request()->get("dep") != ""){
        $consulta .= " AND dpto.NOM_DPTO = '".strtoupper(request()->get("dep"))."'";
    }
    
    if(request()->get("muni") != "undefined" && request()->get("muni") != ""){
        $consulta .= " AND muni.NOM_MUNI = '".strtoupper(request()->get("muni"))."'";
    }
	
	if(request()->get("id") != "undefined" && request()->get("id") != "null" && request()->get("id") != '' && request()->get("id") != '0' ){
        $consulta .= " AND proyectos.secretaria_proyect = '".request()->get("id")."'";
    }
	
	$consulta .= " AND (proyectos.estado_proyect = 'Ejecutado' || proyectos.estado_proyect = 'En Ejecucion') ";
    
    $proyectos = DB::connection("mysql")->table($value . ".ubic_proyect")
            ->leftJoin($value . ".proyectos",$value . ".ubic_proyect.proyect_ubi",$value . ".proyectos.id_proyect")
			->join($value.".muni",$value.".muni.COD_MUNI","muni_ubic")
			->join($value.".dpto",$value.".dpto.COD_DPTO","depar_ubic")
            ->whereRaw($consulta)
            //->where($value . ".proyectos.secretaria_proyect",request()->get("id"))
            ->get();  
	
    return response()->json([
                'proyectos' => $proyectos,
				'cantidad' => count($proyectos)
    ]);
});



Route::get('/proyecto', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
    
    $proyecto = DB::connection("mysql")->table($value . ".proyectos")
            ->where($value . ".proyectos.id_proyect",request()->get("id"))
            ->first();  

	//dd($estado_inicial);die;

    $estado_inicialc =  DB::connection("mysql")->table($value . ".contrato_galeria")
            ->join($value . ".contratos",$value . ".contrato_galeria.contr_galeria",$value . ".contratos.id_contrato")
            ->where($value . ".contratos.idproy_contrato",request()->get("id"))
			->where("estcont_contra","Verificado")
           ->where("tip_galeria","Estado Inicial")
			->select("img_galeria")
			->selectRaw("'C' as tipo, num_contrato_galeria as numero");
	

	$estado_inicial=  DB::connection("mysql")->table($value . ".proyecto_galeria")
            ->where($value . ".proyecto_galeria.proyect_galeria",request()->get("id"))
           ->where("tip_galeria","Estado Inicial")
		->select("img_galeria")
		->selectRaw("'P' as tipo, num_proyect_galeria as numero")
            ->unionAll($estado_inicialc)->get(); 
	
	//dd(request()->get("id"));die;
   
   $avancesc =  DB::connection("mysql")->table($value . ".contrato_galeria")
           ->join($value . ".contratos",$value . ".contrato_galeria.contr_galeria",$value . ".contratos.id_contrato")
            ->where($value . ".contratos.idproy_contrato",request()->get("id"))
           ->where("tip_galeria","Avances")
	   ->select("img_galeria")
	   ->selectRaw("'C' as tipo, num_contrato_galeria as numero")
	   ->where("estcont_contra","Verificado"); 
	
	$avances=  DB::connection("mysql")->table($value . ".proyecto_galeria")
            ->where($value . ".proyecto_galeria.proyect_galeria",request()->get("id"))
           ->where("tip_galeria","Avances")
	   ->select("img_galeria")
		->selectRaw("'P' as tipo, num_proyect_galeria as numero")
		->unionAll($avancesc)
            ->get(); 
	
	
   
   $estado_finalc =  DB::connection("mysql")->table($value . ".contrato_galeria")
           ->join($value . ".contratos",$value . ".contrato_galeria.contr_galeria",$value . ".contratos.id_contrato")
            ->where($value . ".contratos.idproy_contrato",request()->get("id"))
           ->where("tip_galeria","Estado final")
	   ->select("img_galeria")
	   ->selectRaw("'C' as tipo, num_contrato_galeria as numero")
	   ->where("estcont_contra","Verificado"); 
	
	$estado_final=  DB::connection("mysql")->table($value . ".proyecto_galeria")
            ->where($value . ".proyecto_galeria.proyect_galeria",request()->get("id"))
           ->where("tip_galeria","Estado final")
	   ->select("img_galeria")
		->selectRaw("'P' as tipo, num_proyect_galeria as numero")
		->unionAll($estado_finalc)
            ->get(); 
    
	$metasproductos = DB::connection("mysql")->table($value . ".proyect_metasproducto")
           ->join($value . ".metas_productos",$value . ".proyect_metasproducto.id_meta",$value . ".metas_productos.id")
            ->where($value . ".proyect_metasproducto.cod_proy",request()->get("id"))
            ->get(); 
	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios_proyectos")
		->where("id_con",request()->get("id"))
		->count();
	
	$likes = DB::connection("mysql")->table($value . ".likes_proyectos")
		->where("id_con",request()->get("id"))
		->count();
	
	$rating = DB::connection("mysql")->table($value. ".rating_proyectos")
		->where($value . ".rating_proyectos.num_contrato",request()->get("id"))
		->selectRaw(" SUM(value) as total, count(*) as todos ")
		->first();

    return response()->json([
                'proyecto' => $proyecto,
                'estado_inicial' => ($estado_inicial),
                'avances' => ($avances),
				'estado_final' => ($estado_final),
				//'estado_inicialc' => $estado_inicialc,
                //'avancesc' => $avancesc,
				//'estado_finalc' => $estado_finalc,
				'producto' => $metasproductos,
				'likes' => $likes,
		 		'comentarios' => $comentarios,
		 		'rating' => $rating
				
    ]);
});

Route::get('/contratos', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
    
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    $proyecto = DB::connection("mysql")->table($value . ".proyectos")->where("id_proyect",$id)->first();
    //$dptos = DB::table($value . ".dpto")
    //        ->get();
           
           $contratos=DB::connection("mysql")->select("select * from (SELECT
                   MAX(id_contrato) AS id_con,
                       vfin_contrato AS vfin,
                       num_contrato AS num,
                       vcontr_contrato AS vcon
               FROM
                   ".$value.".contratos
               WHERE
                   estcont_contra = 'Verificado'
               GROUP BY num_contrato) as cons
    INNER JOIN
    ".$value.".contratos g ON cons.id_con = g.id_contrato
           LEFT JOIN ".$value.".contrato_galeria c ON c.contr_galeria = g.id_contrato
        WHERE
         g.idproy_contrato='".$proyecto->id_proyect."'
           GROUP BY g.id_contrato");
           //WHERE
                                          // ".$value.".contratos.idproy_contrato='".$proyecto->id_proyect."'");
           
    /*$contratos = DB::connection("mysql")->table($value . ".contratos")
            ->join($value . ".contrato_galeria",$value . ".contrato_galeria.contr_galeria",$value . ".contratos.id_contrato")
            ->where($value . ".contratos.idproy_contrato",$proyecto->id_proyect)
            ->groupBy($value . ".contratos.id_contrato")
            ->get();*/
    
    return response()->json([
                'proyecto' => $proyecto,
                'contratos' => $contratos
    ]);
});

Route::get('/contrato', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
    
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    $contrato = DB::connection("mysql")
           ->table($value . ".contratos")
           ->join($value . ".interventores",$value . ".contratos.idinterv_contrato",$value . ".interventores.id_interventores")
           ->where("id_contrato",$id)
           ->first();
    //$dptos = DB::table($value . ".dpto")
    //        ->get();
   $estado_inicialc =  DB::connection("mysql")->table($value . ".contrato_galeria")
            ->join($value . ".contratos",$value . ".contrato_galeria.contr_galeria",$value . ".contratos.id_contrato")
            ->where($value . ".contratos.num_contrato",$contrato->num_contrato)
           ->where("tip_galeria","Estado Inicial")
            ->get();
	
	//dd(request()->get("id"));die;
   
   $avancesc =  DB::connection("mysql")->table($value . ".contrato_galeria")
           ->join($value . ".contratos",$value . ".contrato_galeria.contr_galeria",$value . ".contratos.id_contrato")
            ->where($value . ".contratos.num_contrato",$contrato->num_contrato)
           ->where("tip_galeria","Avances")
            ->get(); 
   
   $estado_finalc =  DB::connection("mysql")->table($value . ".contrato_galeria")
           ->join($value . ".contratos",$value . ".contrato_galeria.contr_galeria",$value . ".contratos.id_contrato")
            ->where($value . ".contratos.num_contrato",$contrato->num_contrato)
           ->where("tip_galeria","Estado final")
            ->get(); 
	
	$likes = DB::connection("mysql")->table($value . ".likes")
		->where("id_con",$contrato->num_contrato)
		->count();
	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios")
		->where("id_con",$contrato->id_contrato)
		->count();
	
	$rating = DB::connection("mysql")->table($value. ".rating")
		->where($value . ".rating.num_contrato",$contrato->num_contrato)
		->selectRaw(" SUM(value) as total, count(*) as todos ")
		->first();
	
	//dd($likes);die;
    
     return response()->json([
                'contrato' => $contrato,
				'estado_inicial' => $estado_inicialc,
                'avances' => $avancesc,
				'estado_final' => $estado_finalc,
		 		'likes' => $likes,
		 		'comentarios' => $comentarios,
		 		'rating' => $rating
    ]);
});

Route::get('/likes', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();

	
	$likes = DB::connection("mysql")->table($value . ".likes")
		->where("id_con",request()->get("id_con"))
		->where("id_usu",request()->get("id_usu"))
		->first();
	
	if($likes){
		$likes1 = DB::connection("mysql")->table($value . ".likes")
		->where("id_con",request()->get("id_con"))
		->where("id_usu",request()->get("id_usu"))
		->delete();
	}else{
		$likes1 = DB::connection("mysql")->table($value. ".likes")
           ->insert(
                    [
						'id_usu' => $data['id_usu'],
                    'id_con' => $data['id_con'],
                    'estado' => 'Activo',
					]
           );
	}
	
	$likes = DB::connection("mysql")->table($value . ".likes")
		->where("id_con",request()->get("id_con"))
		->count();
    
     return response()->json([
		 		'likes' => $likes
    ]);
});

Route::get('/likes_proyectos', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();
	
	$likes = DB::connection("mysql")->table($value . ".likes_proyectos")
		->where("id_con",request()->get("id_con"))
		->where("id_usu",request()->get("id_usu"))
		->first();
	
	if($likes){
		$likes1 = DB::connection("mysql")->table($value . ".likes_proyectos")
		->where("id_con",request()->get("id_con"))
		->where("id_usu",request()->get("id_usu"))
		->delete();
	}else{
		$likes1 = DB::connection("mysql")->table($value. ".likes_proyectos")
           ->insert(
                    [
						'id_usu' => $data['id_usu'],
                    'id_con' => $data['id_con'],
                    'estado' => 'Activo',
					]
           );
		//$likes1 = \App\likes::guardar($data);
	}
	
	$likes = DB::connection("mysql")->table($value . ".likes_proyectos")
		->where("id_con",request()->get("id_con"))
		->count();
    
     return response()->json([
		 		'likes' => $likes
    ]);
});

Route::get('/comentarios', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();
	$bdadd = "bd_gmp2"; 
	
	$keytoken1="";
	

	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios")
		->where("id_con",request()->get("id_con"))
		->where("response","0")
		->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
		->select($value.".comentarios.*","bd_gmp2.users.nombre","bd_gmp2.users.imagen","bd_gmp2.users.id as id_usu")
		->selectRaw("'false' as expandir")
		->get();
	
	foreach($comentarios as $comentario){
		$respuestas = DB::connection("mysql")->table($value.".comentarios")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
			->select($value.".comentarios.id as id_comentario", $value.".comentarios.comentario",$value.".comentarios.fecha",$value.".comentarios.hora","bd_gmp2.users.nombre","bd_gmp2.users.imagen")
			->where($value.".comentarios.response",$comentario->id)
			->get();
                
                $contador = DB::connection("mysql")->table($value.".comentarios")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
			->select($value.".comentarios.comentario","bd_gmp2.users.nombre")
			->where($value.".comentarios.response",$comentario->id)
			->count();
                
		$comentario->respuestas = $respuestas;
                $comentario->response = $contador;
		
	}
     return response()->json([
		 		'comentarios' => $comentarios
    ]);
});

Route::get('/comentario/guardar', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();
	
	$guardar = DB::connection("mysql")->table($value. ".comentarios")
           ->insert(
                    [
						'id_usu' => $data['id_usu'],
                    'id_con' => $data['id_con'],
                    'estado' => 'Activo',
		    'response' => $data['response'],
		    'comentario' => $data['comentario'],
		    'fecha' => date("Y-m-d"),
		    'hora' => date("H:i:s"),
					]
           );
	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios")
		->where("id_con",request()->get("id_con"))
		->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
		->select($value.".comentarios.*","bd_gmp2.users.nombre")
		->get();


    if(intval($data['response']) != "0"){
        
        $usuarios = (array) DB::connection("mysql")->table("bd_gmp2.users")
            ->join($value.".comentarios",$value.".comentarios.id_usu","users.id")
            ->where("comentarios.id",$data['response'])
            ->first();

        $keytoken[] = $usuarios['token_fcm'];
        
        $usuario = (array) DB::connection("mysql")->table("bd_gmp2.users")
                ->where("id",$data['id_usu'])
                ->first();
        
        if($usuarios['id_usu'] !=  $usuario['id']){
            guardar_notificacion($usuarios['id_usu'], $data['response'], 2, $value, $usuario['nombre']." respondió un comentario tuyo,", $usuario['id']);
            enviar_mensaje($keytoken,$usuario['nombre']." respondió un comentario tuyo.","respuesta a contrato");
        }
    }

     return response()->json([
		 		'comentarios' => $comentarios
    ]);
});


////////////////COMENTARIOS PROYECTOS
Route::get('/comentarios_proyectos', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();
	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios_proyectos")
		->where("id_con",request()->get("id_con"))
		->where("response","0")
		->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
		->select($value.".comentarios_proyectos.*","bd_gmp2.users.nombre","bd_gmp2.users.imagen","bd_gmp2.users.id as id_usu")
		->selectRaw("'false' as expandir")
		->orderBy("id","desc")
		->get();
	
	foreach($comentarios as $comentario){
		$respuestas = DB::connection("mysql")->table($value.".comentarios_proyectos")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
			->select($value.".comentarios_proyectos.id as id_comentario", $value.".comentarios_proyectos.comentario",$value.".comentarios_proyectos.fecha",$value.".comentarios_proyectos.hora","bd_gmp2.users.nombre","bd_gmp2.users.imagen")
			->where($value.".comentarios_proyectos.response",$comentario->id)
			->get();
                
                $contador = DB::connection("mysql")->table($value.".comentarios_proyectos")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
			->select($value.".comentarios_proyectos.comentario","bd_gmp2.users.nombre")
			->where($value.".comentarios_proyectos.response",$comentario->id)
			->count();
                
		$comentario->respuestas = $respuestas;
                $comentario->response = $contador;
		
	}

     return response()->json([
		 		'comentarios' => $comentarios
    ]);
});

Route::get('/comentarios_proyectos_respuestas', function () {
	header("Access-Control-Allow-Origin: *");
	$id = request()->get("id");
	$value = request()->get("bd");
	
	$respuestas = DB::connection("mysql")->table($value.".comentarios_proyectos")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
			->select($value.".comentarios_proyectos.id as id_comentario", $value.".comentarios_proyectos.comentario",$value.".comentarios_proyectos.fecha",$value.".comentarios_proyectos.hora","bd_gmp2.users.nombre","bd_gmp2.users.imagen","bd_gmp2.users.id as id_usu")
			->where($value.".comentarios_proyectos.response",$id)
			->orderBy("comentarios_proyectos.id","asc")
			->get();
	
	return response()->json([
		 		'respuestas' => $respuestas
    ]);
	
});

Route::get('/comentarios_respuestas', function () {
	header("Access-Control-Allow-Origin: *");
	$id = request()->get("id");
	$value = request()->get("bd");
	
	$respuestas = DB::connection("mysql")->table($value.".comentarios")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
			->select($value.".comentarios.id as id_comentario", $value.".comentarios.comentario",$value.".comentarios.fecha",$value.".comentarios.hora","bd_gmp2.users.nombre","bd_gmp2.users.imagen","bd_gmp2.users.id as id_usu")
			->where($value.".comentarios.response",$id)
			->orderBy("comentarios.id","asc")
			->get();
	
	return response()->json([
		 		'respuestas' => $respuestas
    ]);
	
});

Route::get('/comentario_proyectos/guardar', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();
	$datos = "";
	
	//$guardar = \App\comentarios::guardar($data);
	$likes1 = DB::connection("mysql")->table($value. ".comentarios_proyectos")
           ->insert(
                    [
						'id_usu' => $data['id_usu'],
                    'id_con' => $data['id_con'],
                    'estado' => 'Activo',
		    'response' => $data['response'],
		    'comentario' => $data['comentario'],
		    'fecha' => date("Y-m-d"),
		    'hora' => date("H:i:s"),
					]
           );
	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios_proyectos")
		->where("id_con",request()->get("id_con"))
		->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
		->select($value.".comentarios_proyectos.*","bd_gmp2.users.nombre")
		->get();
	
		
	if(intval($data['response']) != "0"){
		$datos = "Entando";
		$usuarios = (array) DB::connection("mysql")->table("bd_gmp2.users")
			->join($value.".comentarios_proyectos",$value.".comentarios_proyectos.id_usu","users.id")
			->where("comentarios_proyectos.id",$data['response'])
			->first();
		$keytoken[] = $usuarios['token_fcm'];
		
		$usuario = (array) DB::connection("mysql")->table("bd_gmp2.users")
				->where("id",$data['id_usu'])
				->first();
        
        if($usuarios['id_usu'] !=  $usuario['id']){
            guardar_notificacion($usuarios['id_usu'], $data['response'], 1, $value, $usuario['nombre']." respondió un comentario tuyo,", $usuario['id']);
		    enviar_mensaje($keytoken,$usuario['nombre']." respondió un comentario tuyo.",$data['id_con']);
        }
	}

     return response()->json([
		 		'comentarios' => $keytoken
    ]);
});


///////////COMENTARIOS EJEMPLOS


Route::get('/registrar', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = "bd_gmp2";
	$countexiste=0;
	$data = request()->all();
    //dd(request()->all());die;
	$usuario=null;
    
    $existe = DB::connection("mysql")->table($value . ".users")->where("email",$data['email'])
		->first();
	
	$edad = obtener_edad_segun_fecha($data['fecha']);
	
	if($edad < 18){
		$countexiste = 99;
	}else{
	
	$countexiste = count($existe);
	if($countexiste == 0){
		$usuario = \App\users::guardar($data);
	}
	}
     return response()->json([
                'usuario' => $usuario,
				'existe' => $countexiste,
    ]);
});

Route::get('/listadosecretarias', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$countexiste=0;
	$data = request()->all();
    //dd(request()->all());die;
    
    $secretarias = DB::connection("mysql")->table($value . ".secretarias")
            ->join($value . ".proyectos",$value .".proyectos.secretaria_proyect",
                    $value.".secretarias.idsecretarias")
            ->join($value.".contratos",$value.".contratos.idproy_contrato",$value.".proyectos.id_proyect")
            ->select($value.".secretarias.des_secretarias")
            ->selectRaw("count(*) as num_contrato, sum(vcontr_contrato) as monto")
            ->groupBy($value.".secretarias.idsecretarias")
            ->get();
	
	foreach($secretarias as $sec){
        $valor = DB::table($value . ".secretarias")
        ->join($value.".presupuesto_secretarias","presupuesto_secretarias.id_secretaria","secretarias.idsecretarias")
        ->select("presupuesto_secretarias.valor")
        ->where("presupuesto_secretarias.id_secretaria",$sec->idsecretarias)
        ->first();
        $sec->presupuesto = $valor->valor;
    } 
    
    //dd($secretarias);die;

     return response()->json([
                'secretarias' => $secretarias,
    ]);
});

Route::get('/listadosecretarias', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$countexiste=0;
	$data = request()->all();
    //dd(request()->all());die;
           
           $secretarias =DB::connection("mysql")
           ->select("SELECT count(*) as num_contrato, sum(vcontr_contrato) as monto,s.des_secretarias,s.idsecretarias
           FROM
               (SELECT
                   MAX(id_contrato) AS id_con,
                       vfin_contrato AS vfin,
                       num_contrato AS num,
                       vcontr_contrato AS vcon,
                       id_contrato
               FROM
                ".$value.".contratos
               WHERE
                   estcont_contra = 'Verificado'
                GROUP BY num_contrato) AS cons JOIN ".$value.".contratos c ON c.id_contrato = cons.id_contrato
                    JOIN ".$value.".proyectos p ON p.id_proyect = c.idproy_contrato
                    JOIN ".$value.".secretarias s ON s.idsecretarias = p.secretaria_proyect group by s.idsecretarias");
    
    
    /*$secretarias = DB::connection("mysql")->table($value . ".secretarias")
            ->join($value . ".proyectos",$value .".proyectos.secretaria_proyect",
                    $value.".secretarias.idsecretarias")
            ->join($value.".contratos",$value.".contratos.idproy_contrato",$value.".proyectos.id_proyect")
            ->select($value.".secretarias.des_secretarias",$value.".secretarias.idsecretarias")
            ->selectRaw("count(*) as num_contrato, sum(vcontr_contrato) as monto")
            ->groupBy($value.".secretarias.idsecretarias")
            ->get();*/
    
    //dd($secretarias);die;
	
	foreach($secretarias as $sec){
        $valor = DB::table($value . ".secretarias")
        ->join($value.".presupuesto_secretarias","presupuesto_secretarias.id_secretaria","secretarias.idsecretarias")
        ->select("presupuesto_secretarias.valor")
        ->where("presupuesto_secretarias.id_secretaria",$sec->idsecretarias)
        ->first();
        $sec->presupuesto = $valor->valor;
    } 
    
    return response()->json([
                'secretarias' => $secretarias,
    ]);
});

Route::get('/listadosecretarias2', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$countexiste=0;
	$data = request()->all();
    //dd(request()->all());die;
    
    $secretarias = DB::connection("mysql")->select("SELECT s.idsecretarias, s.des_secretarias, ps.valor from ".$value.".secretarias s INNER JOIN ".$value.".presupuesto_secretarias ps on ps.id_secretaria = s.idsecretarias INNER JOIN ".$value.".proyectos p on p.secretaria_proyect = s.idsecretarias GROUP by s.idsecretarias");  
    
    foreach($secretarias as $sec){
        $valor = DB::connection("mysql")->select("SELECT IF(SUM(bpp.total) <> 0 , SUM(bpp.total), 0) as comprometido FROM ".$value.".proyectos p INNER JOIN ".$value.".banco_proyec_presupuesto bpp ON p.id_proyect = bpp.id_proyect WHERE p.comp_pres = 'si' AND p.secretaria_proyect = ".$sec->idsecretarias);  
        $sec->comprometido = $valor[0]->comprometido;
    } 

    foreach($secretarias as $sec){
        $valor = DB::connection("mysql")->select("SELECT IF(COUNT(p.id_proyect) = 0, 0, COUNT(p.id_proyect))as cantidad_proyectos FROM ".$value.".proyectos p WHERE p.comp_pres = 'si' AND p.secretaria_proyect = ".$sec->idsecretarias);  
        $sec->cp = $valor[0]->cantidad_proyectos;
    } 

    foreach($secretarias as $sec){
        $valor = DB::connection("mysql")->select("SELECT p.id_proyect, p.nombre_proyect, p.dsecretar_proyect , p.estado_proyect,up.lat_ubic, up.long_ubi, p.secretaria_proyect, p.comp_pres FROM ".$value.".proyectos p INNER JOIN ".$value.".ubic_proyect up on up.proyect_ubi = p.id_proyect GROUP BY p.id_proyect HAVING p.comp_pres = 'si' AND p.secretaria_proyect = ".$sec->idsecretarias);  
        $sec->proyects = $valor;
    } 

    return response()->json([
                'secretarias' => $secretarias,
    ]);
});


Route::get('/graficadetalles', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$countexiste=0;
	$data = request()->all();
    //dd(request()->all());die;
    
    $contratos =DB::connection("mysql")
              ->select("SELECT c.*
              FROM
                  (SELECT
                      MAX(id_contrato) AS id_con,
                          vfin_contrato AS vfin,
                          num_contrato AS num,
                          vcontr_contrato AS vcon,
                          id_contrato
                  FROM
                   ".$value.".contratos
                  WHERE
                      estcont_contra = 'Verificado'
                   GROUP BY num_contrato) AS cons JOIN ".$value.".contratos c ON c.id_contrato = cons.id_contrato
                       JOIN ".$value.".proyectos p ON p.id_proyect = c.idproy_contrato
                       JOIN ".$value.".secretarias s ON s.idsecretarias = p.secretaria_proyect
                       WHERE s.idsecretarias = '".$data['id_con']."'" );

     return response()->json([
                'contratos' => $contratos,
    ]);
});

Route::get('/rfacebook', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = "bd_gmp2";
	$countexiste=0;
	$data = request()->all();
    //dd(request()->all());die;

    $usuario = DB::connection("mysql")->table($value . ".users")
            ->select($value.".users.*")
			->where($value.".users.email",$data['email'])
            ->first();
	
	//var_dump($usuario);die;
	if($usuario == null){
		$usuario = \App\users::guardar($data);
	}
    
     return response()->json([
                'usuario' => $usuario,
    ]);
});

Route::get('/vrfacebook', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = "bd_gmp2";
	$countexiste=0;
	$data = request()->all();
    //dd(request()->all());die;

    $usuario = DB::connection("mysql")->table($value . ".users")
            ->select($value.".users.*")
			->where($value.".users.email",$data['email'])
            ->exists();
	
    
     return response()->json([
                'usuario' => $usuario,
    ]);
});


Route::get('/guardarrating', function () {
    header("Access-Control-Allow-Origin: *");
    $contrato = request()->get("num_contrato");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();
	
	$rating = DB::connection("mysql")->table($value . ".rating")
		->where("num_contrato",request()->get("num_contrato"))
		//->where("id_usu",request()->get("id_usu"))
		->first();
	
	if($rating){
		$likes1 = DB::connection("mysql")->table($value . ".rating")
		->where("num_contrato",request()
		->get("num_contrato"))
		->delete();
	}
    $likes1 = DB::connection("mysql")->table($value. ".rating")
           ->insert(
                    ['value' => $data['value'], 'num_contrato' => $data['num_contrato']]
           );
    //$likes1 = \App\rating::guardar($data,$value);
	
	/*$rating = DB::table($value . ".rating")
		->where("id_con",request()->get("id_con"))
		->count();*/
     return response()->json([
		 		'rating' => $rating
    ]);
});

Route::get('/guardarrating_proyectos', function () {
    header("Access-Control-Allow-Origin: *");
    $contrato = request()->get("num_contrato");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();
	
	$rating = DB::connection("mysql")->table($value . ".rating")
		->where("num_contrato",request()->get("num_contrato"))
		//->where("id_usu",request()->get("id_usu"))
		->first();
	
	if($rating){
		$likes1 = DB::connection("mysql")->table($value . ".rating")
		->where("num_contrato",request()
		->get("num_contrato"))
		->delete();
	}
    $likes1 = DB::connection("mysql")->table($value. ".rating_proyectos")
           ->insert(
                    ['value' => $data['value'],
					 'num_contrato' => $data['num_contrato']]
           );

     return response()->json([
		 		'rating' => $rating
    ]);
});


/*Route::get('/guardarrating', function () {
    header("Access-Control-Allow-Origin: *");
    $contrato = request()->get("num_contrato");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$key = "DB_DATABASE";
    $path = base_path('.env');
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();

    if (is_bool(env("DB_DATABASE"))) {
        $old = env("DB_DATABASE") ? 'true' : 'false';
    } elseif (env("DB_DATABASE") === null) {
        $old = 'null';
    } else {
        $old = env("DB_DATABASE");
    }
    
     if (file_exists($path)) {
        file_put_contents($path, str_replace(
            "$key=".$old, "$key=".$value, file_get_contents($path)
        ));
    }else{
        dd("No existe");die;
    }

		$rating = DB::reconnect("mysql")->table($value . ".rating")
		->where("num_contrato",request()->get("num_contrato"))
		//->where("id_usu",request()->get("id_usu"))
		->first();
	
	if($rating){
		$likes1 = DB::connection("mysql")->table("rating")
		->where("num_contrato",request()
		->get("num_contrato"))
		->delete();
	}
    $likes1 = \App\rating::guardar($data,$value);
	
	/*$rating = DB::table($value . ".rating")
		->where("id_con",request()->get("id_con"))
		->count();*/
    
    /* return response()->json([
		 		'rating' => $rating
    ]);
	
	
});*/

Route::get('/puntuacion', function () {
    header("Access-Control-Allow-Origin: *");
    $contrato = request()->get("num_contrato");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();

	$rating = DB::connection("mysql1")->table("rating")
		->where("num_contrato",request()->get("num_contrato"))
		->selectRaw("SUM(value) as total,count(*) as todos")
		->first();

     return response()->json([
		 		'rating' => $rating
    ]);
	
	
});

Route::get('/puntuacion_proyectos', function () {
    header("Access-Control-Allow-Origin: *");
    $contrato = request()->get("num_contrato");
    $value = request()->get("bd");
    //dd(request()->all());die;
	$data = request()->all();

	$rating = DB::connection("mysql1")->table("rating_proyectos")
		->where("num_contrato",request()->get("num_contrato"))
		->selectRaw("SUM(value) as total,count(*) as todos")
		->first();

     return response()->json([
		 		'rating' => $rating
    ]);
	
	
});
    
    Route::get('/editarperfil', function () {
        header("Access-Control-Allow-Origin: *");
        $id = request()->get("id");
        $nombre = request()->get("nombre");
        $email = request()->get("email");
		$bio = request()->get("bio");
        
        $value = "bd_gmp2";
        //dd(request()->all());die;
        $data = request()->all();
        $mensaje = "";
                
        $usuario = DB::connection("mysql")->table($value. ".users")
                ->where("id",$id)
                ->first();
                
        /*$data['imagen'] = request()->get("id").".jgp";
                
                $ruta_real = public_path();
                $valido = "no";
                $ruta_real .="/images/foto";
                $imagen_nombre = time().".jpg";
                $target_path = $ruta_real."/".$imagen_nombre;
                $hasFile1 = request()->hasFile('file');
                //dd($target_path);die;
                //$target_path = public_path()."/prueba.jpg";
                if(request()->get("imagen") == "si"){
                   $valido="si";
                   $imagedata = request()->get("file");
                   $imagedata = str_replace("data:image/jpeg;base64","",$imagedata);
                   $imagedata = str_replace("data:image/jpg;base64","",$imagedata);
                   $imagedata = str_replace(" ","+",$imagedata);
                   $imagedata = base64_decode($imagedata);
                   file_put_contents($target_path,$imagedata);
                    $user = DB::connection("mysql")->table($value. ".users")
                    ->where("id",$id)
                    ->update(
                             [
                             'imagen' => $imagen_nombre,
                             ]
                    );
                   if($user){
                       Storage::delete($ruta_real."/".$usuario->imagen);
                   }
                }*/
                
                $user = DB::connection("mysql")->table($value. ".users")
                ->where("id",$id)
                ->update(
                         [
                         'email' => $email,
                         'nombre' => $nombre,
							 'bio' => $bio,
                         ]
                );
        
        
        //$likes1 = \App\rating::guardar($data,$value);
        
        /*$rating = DB::table($value . ".rating")
            ->where("id_con",request()->get("id_con"))
            ->count();*/
                
        $usuario = DB::connection("mysql")->table($value. ".users")
                ->where("id",$id)
                ->first();
        
         return response()->json([
                    'mensaje' => "1",
                    'usuario' => $usuario
        ]);
    });
    
    Route::get('/cambiarpass', function () {
        header("Access-Control-Allow-Origin: *");
        
        $value = "bd_gmp2";
    
        $data = request()->all();
              
               $mensaje="";
               
               $logueo = false;
               $usuario = false;
               $data = request()->all();
               $usuario = \App\users::login($data['email'], "");
               if ($usuario && \Hash::check($data['actual'], $usuario->pasword)) {
                   //auth()->loginUsingId($usuario->id);
                   $mensaje = "ok";
               $user = DB::connection("mysql")->table($value. ".users")
                      ->where("id",$data["id"])
                      ->update(
                               [
                               'pasword' => bcrypt($data["nueva"]),
                               ]
                      );
                    
               } else {
                   $mensaje = "no";
               }

         return response()->json([
                    'mensaje' => $mensaje
        ]);
        
        
    });


Route::get('/verperfil', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = "bd_gmp2";
    //dd(request()->all());die;
	$data = request()->all();

	$rating = DB::connection("mysql1")->table($value.".users")
		->where("id",request()->get("id"))
		->first();

     return response()->json([
		 		'datos' => $rating
    ]);
	
	
});

Route::get('/buscarproyectos',function(){
	header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;

    $proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.nombre_proyect",'like','%'.request()->get("bus").'%')
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();
    
    return response()->json([
                'proyectos' => $proyectos,
    ]);
});

Route::get('/buscarproyectosestados',function(){
	header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;

	
		
	if($id != "0"){
		$proyectos = DB::connection("mysql")->table($value . ".proyectos")
			->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.estado_proyect",'=',request()->get("estado"))
		->groupBy($value . ".proyectos.id_proyect")
			->where($value . ".proyectos.secretaria_proyect",$id)
			->get();
		
	}else{
		$proyectos = DB::connection("mysql")->table($value . ".proyectos")
			->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.estado_proyect",'=',request()->get("estado"))
		->groupBy($value . ".proyectos.id_proyect")->get();
	}

    
    return response()->json([
                'proyectos' => $proyectos,
    ]);
});


Route::get('/busproyectos',function(){
	header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    
    $value = request()->get("bd");
    //dd(request()->all());die;
	
	$consulta = "1 ";
	
	if(request()->get("dep") != "undefined" && request()->get("dep") != "" && request()->get("dep") != "0"){
        $consulta .= " AND depar_ubic = '".request()->get("dep")."'";
    }
    
    if(request()->get("mun") != "undefined" && request()->get("mun") != "" && request()->get("mun") != "0"){
        $consulta .= " AND muni_ubic = '".request()->get("mun")."'";
    }
    
    if(request()->get("cor") != "undefined" && request()->get("cor") != "" && request()->get("cor") != "0"){
        $consulta .= " AND corr_ubic = '".request()->get("cor")."'";
    }
	
	if(request()->get("id") != "undefined" && request()->get("id") != "null" && request()->get("id") != '' && request()->get("id") != "0" ){
        $consulta .= " AND proyectos.secretaria_proyect = '".request()->get("id")."'";
    }
	
	$consulta .= " AND (proyectos.estado_proyect = 'Ejecutado' || proyectos.estado_proyect = 'En Ejecucion') ";

    $proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
		->leftJoin($value . ".ubic_proyect",$value . ".ubic_proyect.proyect_ubi",$value . ".proyectos.id_proyect")
            ->whereRaw($consulta)
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();
    
    return response()->json([
                'proyectos' => $proyectos,
    ]);
});

Route::get('/secretariaestado', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	
	if($id == 0){
    
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    $secretaria = DB::connection("mysql")->table($value . ".secretarias")->where("idsecretarias",$id)->first();
    //$dptos = DB::table($value . ".dpto")
    //        ->get();
           
    $proyectos_ejecucion=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","En Ejecución")
           ->count();
    $proyectos_priorizados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Priorizado")
           ->count();
    $proyectos_ejecutados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Ejecutado")
          
           ->count();
    $proyectos_radicados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Radicado")
           
           ->count();
           
           $proyectos_no=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","No Viabilizado")
          
           ->count();
           
           $proyectos_registrados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Registrado")
           
           ->count();
    /*$proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->join($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.secretaria_proyect",$secretaria->idsecretarias)
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();*/
	
	$dptos = DB::connection("mysql")->table($value . ".dpto")
		->get();
	}else{
    
    //$secretaria = DB::select("select * from " . $value . ".secretarias WHERE idsecretarias = '".$id."'");
    $secretaria = DB::connection("mysql")->table($value . ".secretarias")->where("idsecretarias",$id)->first();
    //$dptos = DB::table($value . ".dpto")
    //        ->get();
           
    $proyectos_ejecucion=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","En Ejecución")
           ->where($value . ".proyectos.secretaria_proyect",$id)
           ->count();
    $proyectos_priorizados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Priorizado")
           ->where($value . ".proyectos.secretaria_proyect",$id)
           ->count();
    $proyectos_ejecutados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Ejecutado")
           ->where($value . ".proyectos.secretaria_proyect",$id)
           ->count();
    $proyectos_radicados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Radicado")
           ->where($value . ".proyectos.secretaria_proyect",$id)
           ->count();
           
           $proyectos_no=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","No Viabilizado")
           ->where($value . ".proyectos.secretaria_proyect",$id)
           ->count();
           
           $proyectos_registrados=DB::connection("mysql")->table($value . ".proyectos")
           ->where($value . ".proyectos.estado_proyect","Registrado")
           ->where($value . ".proyectos.secretaria_proyect",$id)
           ->count();
    /*$proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->join($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
            ->where($value . ".proyectos.secretaria_proyect",$secretaria->idsecretarias)
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();*/
	
	$dptos = DB::connection("mysql")->table($value . ".dpto")
		->get();
	}
    
    return response()->json([
                'secretaria' => $secretaria,
                'proyectos_ejecucion' => $proyectos_ejecucion,
				'proyectos_priorizados' => $proyectos_priorizados,
                'proyectos_ejecutados' => $proyectos_ejecutados,
                'proyectos_radicados' => $proyectos_radicados,
                            'proyectos_no' => $proyectos_no,
                            'proyectos_registrados' => $proyectos_registrados,
    ]);
});

Route::get('/presupuestosecretaria', function () {
           header("Access-Control-Allow-Origin: *");
           $id = request()->get("id");
           $value = request()->get("bd");
                  //dd(request()->all());die;
           $data = request()->all();
           $mensaje = "";

           $datos_secretaria = DB::connection("mysql")->table($value.".secretarias")
           ->join($value.".presupuesto_secretarias",$value.".presupuesto_secretarias.id_secretaria",$value.".secretarias.idsecretarias")
           ->where($value.".secretarias.idsecretarias",$id)
           ->selectRaw('*,SUM(valor) as total')
           ->groupBy("idsecretarias")
           ->first();
           
           $secretaria = DB::connection("mysql")
           ->select("SELECT
                    s.des_secretarias,SUM(IF(g.vfin_contrato > 0,
                   g.vfin_contrato,
                   g.vcontr_contrato)) AS TOTAL_PROYECTOS,
               SUM(g.veje_contrato) AS TOTAL_EJECUCION_PROYECTOS
           FROM
               (SELECT
                   MAX(id_contrato) AS id_con,
                       vfin_contrato AS vfin,
                       num_contrato AS num,
                       vcontr_contrato AS vcon
               FROM
                ".$value.".contratos
               WHERE
                   estcont_contra = 'Verificado'
               GROUP BY num_contrato) AS cons
                   INNER JOIN
               ".$value.".contratos g ON cons.num = g.num_contrato
                   INNER JOIN
               ".$value.".proyectos p ON p.id_proyect = g.idproy_contrato
                    INNER JOIN
                    ".$value.".secretarias s ON p.secretaria_proyect = s.idsecretarias
           WHERE
               g.id_contrato = cons.id_con
                   AND p.estado = 'ACTIVO'
                    AND s.idsecretarias = '".$id."'
                    AND estado_secretaria='ACTIVO'
                    GROUP BY s.idsecretarias");
                    
            $fuentes = DB::connection("mysql")->table($value.".presupuesto_secretarias")
                    ->join($value.".fuentes",$value.".fuentes.id",$value.".presupuesto_secretarias.id_fuente")
                    ->where("id_secretaria",$id)
                    ->get();
                    
         return response()->json([
        'mensaje' => $mensaje,
        'secretaria' => $secretaria,
        'datos_secretaria' => $datos_secretaria,
        'fuentes' => $fuentes
     ]);
         
           
});

Route::get('/presupuesto_general',function(){
    header("Access-Control-Allow-Origin: *");
           $value = request()->get("bd");
           $mensaje = "";

           $datos_secretaria = DB::connection("mysql")->table($value.".secretarias")
           ->join($value.".presupuesto_secretarias",$value.".presupuesto_secretarias.id_secretaria",$value.".secretarias.idsecretarias")
           ->selectRaw('*,SUM(valor) as total')
           ->where("secretarias.estado_secretaria","ACTIVO")
           ->first();

           $presupuesto_general = DB::connection("mysql")
           ->select("SELECT
                    s.des_secretarias,SUM(IF(g.vfin_contrato > 0,
                   g.vfin_contrato,
                   g.vcontr_contrato)) AS TOTAL_PROYECTOS,
               SUM(g.veje_contrato) AS TOTAL_EJECUCION_PROYECTOS
           FROM
               (SELECT
                   MAX(id_contrato) AS id_con,
                       vfin_contrato AS vfin,
                       num_contrato AS num,
                       vcontr_contrato AS vcon
               FROM
                ".$value.".contratos
               WHERE
                   estcont_contra = 'Verificado'
               GROUP BY num_contrato) AS cons
                   INNER JOIN
               ".$value.".contratos g ON cons.num = g.num_contrato
                   INNER JOIN
               ".$value.".proyectos p ON p.id_proyect = g.idproy_contrato
                    INNER JOIN
                    ".$value.".secretarias s ON p.secretaria_proyect = s.idsecretarias
           WHERE
               g.id_contrato = cons.id_con
                   AND p.estado = 'ACTIVO'
                    AND estado_secretaria='ACTIVO'
                    ");

           return response()->json([
            'presupuesto' => $datos_secretaria->total,
            'presupuesto_general' => $presupuesto_general,
         ]);
});

Route::get('/proyectos_calificaciones',function(){
	header("Access-Control-Allow-Origin: *");
    $value = request()->get("bd");
	$cal = request()->get("cal");
	$sec = request()->get("sec");
    //dd(request()->all());die;
	$numcals = 0;
	$numcali = 0;
	
	if($sec == "0"){
		$sec = "";
	}
	
	if($cal == "Todas las calificaciones"){
		$cal = "";
	}
	
	if(isset($cal) && $cal != ""){
		if($cal == "Excelente"){
			$numcals = 5;
			$numcali = 5;
		}else if($cal == "Bueno"){
			$numcals = 4;
			$numcali = 3;
		}else if($cal == "Regular"){
			$numcals = 2;
			$numcali = 2; 
		}else{
			$numcals = 1;
			$numcali = 1;
		}
	}
	
	
	if(isset($cal) && $cal != "" && isset($sec) && $sec != "" ){
		//print_r("DOS PARAMETROS");die;
    	$proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
			->join($value . ".rating_proyectos",$value . ".rating_proyectos.num_contrato",$value . ".proyectos.id_proyect")
			->join($value . ".secretarias",$value . ".secretarias.idsecretarias",$value . ".proyectos.secretaria_proyect")
			->where($value . ".proyectos.secretaria_proyect",request()->get("sec"))
			->select("proyectos.*","proyecto_galeria.img_galeria","proyecto_galeria.num_proyect_galeria","secretarias.des_secretarias")
			->selectRaw("SUM(rating_proyectos.value)/COUNT(*) as cal")
            ->groupBy($value . ".proyectos.id_proyect")
			->havingRaw("ROUND(SUM(rating_proyectos.value)/COUNT(*)) >= ".$numcals)
			->havingRaw("ROUND(SUM(rating_proyectos.value)/COUNT(*)) <= ".$numcali)
            ->get();
		
		
	}else if(isset($cal) && $cal != ""){

		$proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
			->join($value . ".rating_proyectos",$value . ".rating_proyectos.num_contrato",$value . ".proyectos.id_proyect")
			->join($value . ".secretarias",$value . ".secretarias.idsecretarias",$value . ".proyectos.secretaria_proyect")
			->select("proyectos.*","proyecto_galeria.img_galeria","secretarias.des_secretarias","proyecto_galeria.num_proyect_galeria")
			->selectRaw("SUM(rating_proyectos.value)/COUNT(*) as cal")
            ->groupBy($value . ".proyectos.id_proyect")
			->havingRaw("ROUND(SUM(rating_proyectos.value)/COUNT(*)) >= ".$numcals)
			->havingRaw("ROUND(SUM(rating_proyectos.value)/COUNT(*)) <= ".$numcali)
            ->get();
	}else if( isset($sec) && $sec != ""){

		$proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
			->join($value . ".rating_proyectos",$value . ".rating_proyectos.num_contrato",$value . ".proyectos.id_proyect")
			->join($value . ".secretarias",$value . ".secretarias.idsecretarias",$value . ".proyectos.secretaria_proyect")
			->where($value . ".proyectos.secretaria_proyect",request()->get("sec"))
			->select("proyectos.*","proyecto_galeria.img_galeria","secretarias.des_secretarias","proyecto_galeria.num_proyect_galeria")
			->selectRaw("SUM(rating_proyectos.value)/COUNT(*) as cal")
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();
	}else{

		$proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
			->join($value . ".rating_proyectos",$value . ".rating_proyectos.num_contrato",$value . ".proyectos.id_proyect")
			->join($value . ".secretarias",$value . ".secretarias.idsecretarias",$value . ".proyectos.secretaria_proyect")
			->select("proyectos.*","proyecto_galeria.img_galeria","secretarias.des_secretarias","proyecto_galeria.num_proyect_galeria")
			->selectRaw("SUM(rating_proyectos.value)/COUNT(*) as cal")
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();
	}
	

    return response()->json([
                'proyectos' => $proyectos,
    ]);
});

   Route::get('/enviarcorreo', function () {
    header("Access-Control-Allow-Origin: *");
	   	$data = array(
                'url' => "Hola mundo"
            );
 Mail::send("correo", $data, function($message) {
                $message->from("no-reply@clannishfx.com", "Clannishfx");
                $message->to("nikle0704@gmail.com")->subject("Verificación de cuenta Clannishfx");
            });
        });

Route::get('/busproyectostexto',function(){
	header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
    //dd(request()->all());die;
	
	$consulta = "1 ";
	
	if(request()->get("dep") != "undefined" && request()->get("dep") != ""){
        $consulta .= " AND dpto.NOM_DPTO = '".strtoupper(request()->get("dep"))."'";
    }
    
    if(request()->get("mun") != "undefined" && request()->get("mun") != ""){
        $consulta .= " AND muni.NOM_MUNI = '".strtoupper(request()->get("mun"))."'";
    }
	
	if(request()->get("id") != "undefined" && request()->get("id") != "null" && request()->get("id") != '' ){
        $consulta .= " AND proyectos.secretaria_proyect = '".request()->get("id")."'";
    }

    $proyectos = DB::connection("mysql")->table($value . ".proyectos")
            ->leftJoin($value . ".proyecto_galeria",$value . ".proyecto_galeria.proyect_galeria",$value . ".proyectos.id_proyect")
			->leftJoin($value . ".ubic_proyect",$value . ".ubic_proyect.proyect_ubi",$value . ".proyectos.id_proyect")
			->join($value.".muni",$value.".muni.COD_MUNI","muni_ubic")
			->join($value.".dpto",$value.".dpto.COD_DPTO","depar_ubic")
            ->whereRaw($consulta)
            ->groupBy($value . ".proyectos.id_proyect")
            ->get();
    
    return response()->json([
                'proyectos' => $proyectos,
				'departamento' => request()->get("dep")
    ]);
});

Route::get('/proyectotitulo',function(){
	header("Access-Control-Allow-Origin: *");
    $titulo = request()->get("titulo");
    $value = request()->get("bd");
    //dd(request()->all());die;

    $proyectos = (array) DB::connection("mysql")->table($value . ".proyectos")
            ->where($value . ".proyectos.nombre_proyect",'=',$titulo)
            ->first();
    
    return response()->json([
                'id' => $proyectos['id_proyect'],
    ]);
});

Route::get("/msg",function(){
	header("Access-Control-Allow-Origin: *");
	$value="bd_gmp2";
	 $users =DB::connection("mysql")->table($value.".users")
               ->where("estado","Activo")
               ->where("token_fcm","<>", null)
               ->get();
	
	foreach ($users as $user) {
           $keytoken1[] = $user ->token_fcm;
   }
	
	$message = "Hay un nuevo proyecto agregado a la plataforma"; // El mensaje que vayas a enviar 
            $title = "GMP"; // Título de la notificación
            $path_to_fcm = "https://fcm.googleapis.com/fcm/send";
            $api_key = "AAAARbZndfo:APA91bHENQXskiYQ8kyaDMmkqutGlPLN1J1ciVyH0hTzUatukBBVAgTCX5CRQxeKylvRLHV8dYpZpgxdzOZCLvBN0jZ30oEVNrDi0uNuYYIs8iTLB8O8tqomslq9e8ROup1hG60a21Q_";

            $headers = array(
                "Authorization:key=" . $api_key,
                "Content-Type:application/json",
            );

            // Para un solo token, si es para varios usar "registration_ids” en vez de "to”.

            $fields = array("registration_ids" => $keytoken1, "notification" => array("title" => $title, "body" => $message, 'sound' => "default",));

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $path_to_fcm);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

            //curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
            $result = curl_exec($ch);
            if ($result == FALSE) {
                die('CURL failed' . curl_error($ch));
            }
            curl_close($ch); 
	//echo "Mensaje";

});

function obtener_edad_segun_fecha($fecha_nacimiento)
{
    $nacimiento = new DateTime($fecha_nacimiento);
    $ahora = new DateTime(date("Y-m-d"));
    $diferencia = $ahora->diff($nacimiento);
    return $diferencia->format("%y");
}


function enviar_mensaje($keytoken1, $titulo,$id){
$message = $titulo; // El mensaje que vayas a enviar 
            $title = "GMP"; // Título de la notificación
            $path_to_fcm = "https://fcm.googleapis.com/fcm/send";
            $api_key = "AAAAITD8gJM:APA91bH92ndr06-WntdaEUA8m8quAsmv96xPGJpqmlGjoa26M0a-y301PSuwkDx6h8zk8-Pb7WtBaXBw-nYc3vLBw6GQsXg3qgurzxNnZEmqm2yz2itvIhBXCj3MCQlOVPsCAsQ9F_H2";

            $headers = array(
                "Authorization:key=" . $api_key,
                "Content-Type:application/json",
            );

            // Para un solo token, si es para varios usar "registration_ids” en vez de "to”.

            $fields = array("registration_ids" => $keytoken1, "notification" => array("title" => $title, "body" => $message, 'sound' => "default", "click_action" => "FCM_PLUGIN_ACTIVITY")
						   ,'priority'=>'high',"data" => array("ir" => "/detalle-proyecto/".$id));

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $path_to_fcm);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

            //curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
            $result = curl_exec($ch);
            if ($result == FALSE) {
                die('CURL failed' . curl_error($ch));
            }
            curl_close($ch);
}


Route::get('/graficainicial',function(){
	header("Access-Control-Allow-Origin: *");
    $value = request()->get("bd");
    $totalContratos = 0;
    $mese = ['',"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];

    $valorContratos = DB::select(
        "select SUM(vfin_contrato) as total from (SELECT
                   MAX(id_contrato) AS id_con,
                       vfin_contrato AS vfin,
                       num_contrato AS num,
                       vcontr_contrato AS vcon
               FROM
                   ".$value.".contratos
               WHERE
                   estcont_contra = 'Verificado'
               GROUP BY num_contrato) as cons
    INNER JOIN
    ".$value.".contratos g ON cons.id_con = g.id_contrato
           "
    );

    $totalContratos = $valorContratos[0]->total;
    
    $mesactual = date("m");
    $anoactual = date("Y");
    $lista = [];

    if(($mesactual - 4) > 1){
        $m1 = (array) DB::table($value . ".contratos")
            ->selectRaw("sum(veje_contrato) as total")
            ->whereRaw("month(ffin_contrato) = ".($mesactual-4)." AND year(ffin_contrato) = ".$anoactual."")
            ->where("estad_contrato","Terminado")
            ->first();
        
        $totalmes = ($m1->total*100)/$valorContratos;     
        
        $lista[] = [
            'mes'=> $mese[$mesactual - 4],
            "valor" => $totalmes 
        ];
            
    }
    
    if(($mesactual - 3) > 1){
        $m1 = (array) DB::table($value . ".contratos")
            ->selectRaw("sum(veje_contrato) as total")
            ->whereRaw("month(ffin_contrato) = ".($mesactual-3)." AND year(ffin_contrato) = ".$anoactual."")
            ->where("estad_contrato","Terminado")
            ->first();
        
        $totalmes = ($m1->total*100)/$valorContratos;     
        
        $lista[] = [
            'mes'=> $mese[$mesactual - 4],
            "valor" => $totalmes 
        ];
            
    }

    if(($mesactual - 2) > 1){
        $m1 = (array) DB::table($value . ".contratos")
            ->selectRaw("sum(veje_contrato) as total")
            ->whereRaw("month(ffin_contrato) = ".($mesactual-2)." AND year(ffin_contrato) = ".$anoactual."")
            ->where("estad_contrato","Terminado")
            ->first();
        
        $totalmes = ($m1->total*100)/$valorContratos;     
        
        $lista[] = [
            'mes'=> $mese[$mesactual - 4],
            "valor" => $totalmes 
        ];
            
    }

    if(($mesactual - 1) > 1){
        $m1 = (array) DB::table($value . ".contratos")
            ->selectRaw("sum(veje_contrato) as total")
            ->whereRaw("month(ffin_contrato) = ".($mesactual-1)." AND year(ffin_contrato) = ".$anoactual."")
            ->where("estad_contrato","Terminado")
            ->first();
        
        $totalmes = ($m1->total*100)/$valorContratos;     
        
        $lista[] = [
            'mes'=> $mese[$mesactual - 4],
            "valor" => $totalmes 
        ];
            
    }

    if(($mesactual) > 1){
        $m1 = (array) DB::table($value . ".contratos")
            ->selectRaw("sum(veje_contrato) as total")
            ->whereRaw("month(ffin_contrato) = ".($mesactual)." AND year(ffin_contrato) = ".$anoactual."")
            ->where("estad_contrato","Terminado")
            ->first();
        
        $totalmes = ($m1->total*100)/$valorContratos;     
        
        $lista[] = [
            'mes'=> $mese[$mesactual - 4],
            "valor" => $totalmes 
        ];
            
    }

    dd($lista);die;

    $proyectos = (array) DB::table($value . ".contratos")
            ->where("proyectos.nombre_proyect",'=',$titulo)
            ->selectRaw("sum(veje_contrato) as total")
            ->whereRaw("month(ffin_contrato) = ")
            ->first();
    
    return response()->json([
                'id' => $proyectos['id_proyect'],
    ]);
});

Route::get('/listar_proyectos_mapa', function () {
    header("Access-Control-Allow-Origin: *");
    
    $value = request()->get("bd");
	
	$proyectos = DB::connection("mysql")->select("SELECT p.id_proyect, p.nombre_proyect, p.dsecretar_proyect , p.estado_proyect,up.lat_ubic, up.long_ubi FROM ".$value.".proyectos p INNER JOIN ".$value.".ubic_proyect up on up.proyect_ubi = p.id_proyect GROUP BY p.id_proyect");
    
    return response()->json([
                'proyectos' => $proyectos,
    ]);
});


Route::get('/contratos-proyectos', function () {
    header("Access-Control-Allow-Origin: *");
    
    $value = request()->get("bd");
    $id_proyecto = request()->get("id");
	
	$proyectos = DB::connection("mysql")->select("SELECT 
        contr.id_contrato,contr.num_contrato ncont,contr.obj_contrato obj,
        contr.descontrati_contrato descontita,
        contr.estad_contrato estado,contr.vfin_contrato total,
        uc.lat_ubic, uc.long_ubi, contr.porav_contrato
    FROM
    ".$value.".contratos contr 
    LEFT JOIN ".$value.".proyectos proy 
    ON contr.idproy_contrato = proy.id_proyect 
    LEFT JOIN ".$value.".secretarias sec
    ON proy.secretaria_proyect=sec.idsecretarias 
    LEFT JOIN ".$value.".ubic_contratos uc
    ON uc.contrato_ubi=contr.id_contrato 
    WHERE contr.estcont_contra='Verificado' AND contr.idproy_contrato='".$id_proyecto."' 
    AND contr.id_contrato IN
      (SELECT
        MAX(id_contrato)
      FROM
      ".$value.".contratos
      GROUP BY num_contrato) GROUP BY ncont ORDER BY total DESC");
    
    return response()->json([
                'contratos' => $proyectos,
    ]);
});


Route::get('/verificar-likes-contrato', function () {
    header("Access-Control-Allow-Origin: *");

    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$data = request()->all();

    $id_usuario = request()->get("id_usu");
    $id_contrato = request()->get("id_con");

	
	$likes = DB::connection("mysql")->select("SELECT count(*) as likes FROM ".$value.".likes WHERE id_usu = ".$id_usuario." and id_con = '".$id_contrato."'");
	
	return response()->json(['like' => $likes]);
});

Route::get('/verificar-likes-proyecto', function () {
    header("Access-Control-Allow-Origin: *");

    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$data = request()->all();

    $id_usuario = request()->get("id_usu");
    $id_proyecto = request()->get("id_pro");

	
	$likes = DB::connection("mysql")->select("SELECT count(*) as likes FROM ".$value.".likes_proyectos WHERE id_usu = ".$id_usuario." and id_con = '".$id_proyecto."'");
	
	return response()->json(['like' => $likes]);
});

function guardar_notificacion($usuario, $comentario, $tipo, $bd, $mensaje, $usuario_responde){
    DB::connection("mysql")->table("bd_gmp2.notificaciones")
    ->insert([
                'id_usuario' => $usuario,
                'id_comentario' => $comentario,
                'tipo_respuesta_comentario' => $tipo,
                'estado' => 1,
                'fecha' => date("Y-m-d"),
                'hora' => date("H:i:s"),
                'bd' => $bd,
                'mensaje' => $mensaje,
				'id_usuario_responde' => $usuario_responde
            ]);
}

Route::get('/notificaciones', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id_usu");
    $value = "bd_gmp2";
	$data = request()->all();
	
	$notificaciones = DB::connection("mysql")->select("SELECT n.*, u.imagen FROM ".$value.".notificaciones n INNER JOIN ".$value.".users u ON u.id = n.id_usuario_responde WHERE n.id_usuario = ".$id." ORDER BY n.id DESC");

    foreach($notificaciones as $not){
        if($not->tipo_respuesta_comentario == 1){
            $detalles = DB::connection("mysql")->select("SELECT c.id, p.id_proyect, p.nombre_proyect as nombre FROM ".$not->bd.".comentarios_proyectos c INNER JOIN ".$not->bd.".proyectos p on p.id_proyect = c.id_con  WHERE c.id =".$not->id_comentario);  
			$not->detalle = $detalles;
        }else{
            $detalles = DB::connection("mysql")->select("SELECT c.id, co.id_contrato, co.obj_contrato as nombre FROM ".$not->bd.".comentarios c INNER JOIN ".$not->bd.".contratos co on c.id_con = co.id_contrato WHERE c.id =".$not->id_comentario);  
			$not->detalle = $detalles;
        }
        
    } 
	
	return response()->json(['notificaciones' => $notificaciones]);
});

Route::get('/cambiar-estado-notificacion', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id_not");
    $value = "bd_gmp2";
	$data = request()->all();
	
	$notificaciones = DB::connection("mysql")->select("UPDATE ".$value.".notificaciones SET estado=0 WHERE id = ".$id);

	return response()->json(['ok' => "Ok"]);
});


Route::get('/comentario_proyectos', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$data = request()->all();
	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios_proyectos")
		->where($value.".comentarios_proyectos.id",request()->get("id"))
		->where("response","0")
		->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
		->select($value.".comentarios_proyectos.*","bd_gmp2.users.nombre","bd_gmp2.users.imagen")
		->selectRaw("'false' as expandir")
		->orderBy("id","desc")
		->get();
	
	foreach($comentarios as $comentario){
		$respuestas = DB::connection("mysql")->table($value.".comentarios_proyectos")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
			->select($value.".comentarios_proyectos.comentario",$value.".comentarios_proyectos.fecha",$value.".comentarios_proyectos.hora","bd_gmp2.users.nombre","bd_gmp2.users.imagen")
			->where($value.".comentarios_proyectos.response",$comentario->id)
			->get();
                
                $contador = DB::connection("mysql")->table($value.".comentarios_proyectos")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios_proyectos.id_usu")
			->select($value.".comentarios_proyectos.comentario","bd_gmp2.users.nombre")
			->where($value.".comentarios_proyectos.response",$comentario->id)
			->count();
                
		$comentario->respuestas = $respuestas;
                $comentario->response = $contador;
		
	}

     return response()->json([
		 		'comentario' => $comentarios
    ]);
});

Route::get('/cambiar-estado-notificacion', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id_not");
    $value = "bd_gmp2";
	$data = request()->all();
	
	$notificaciones = DB::connection("mysql")->select("UPDATE ".$value.".notificaciones SET estado=0 WHERE id = ".$id);

	return response()->json(['ok' => "Ok"]);
});


Route::get('/comentario_contratos', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = request()->get("bd");
	$data = request()->all();
	
	$comentarios = DB::connection("mysql")->table($value . ".comentarios")
		->where($value.".comentarios.id",request()->get("id"))
		->where("response","0")
		->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
		->select($value.".comentarios.*","bd_gmp2.users.nombre","bd_gmp2.users.imagen")
		->selectRaw("'false' as expandir")
		->orderBy("id","desc")
		->get();
	
	foreach($comentarios as $comentario){
		$respuestas = DB::connection("mysql")->table($value.".comentarios")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
			->select($value.".comentarios.comentario",$value.".comentarios.fecha",$value.".comentarios.hora","bd_gmp2.users.nombre","bd_gmp2.users.imagen")
			->where($value.".comentarios.response",$comentario->id)
			->get();
                
                $contador = DB::connection("mysql")->table($value.".comentarios")
			->join("bd_gmp2.users","bd_gmp2.users.id",$value.".comentarios.id_usu")
			->select($value.".comentarios.comentario","bd_gmp2.users.nombre")
			->where($value.".comentarios.response",$comentario->id)
			->count();
                
		$comentario->respuestas = $respuestas;
                $comentario->response = $contador;
		
	}

     return response()->json([
		 		'comentario' => $comentarios
    ]);
});


Route::get('/usuario', function () {
    header("Access-Control-Allow-Origin: *");
    $id = request()->get("id");
    $value = "bd_gmp2";
	$countexiste=0;
	$data = request()->all();

    $usuario = DB::connection("mysql")->table($value . ".users")
            ->select($value.".users.*")
			->where($value.".users.email",$data['email'])
            ->first();
    
     return response()->json([
                'usuario' => $usuario,
    ]);
});

Route::get('/eliminar-comentario', function () {
    header("Access-Control-Allow-Origin: *");
    $value = request()->get("bd");
    $tipo = request()->get("tipo");
	$data = request()->all();

    if($tipo == "proyecto"){
        $respuesta = DB::connection("mysql")->table($value.".comentarios_proyectos")
        ->where("id",request()->get("id_com"))
        ->delete();
    }else{
        $respuesta = DB::connection("mysql")->table($value.".comentarios")
        ->where("id",request()->get("id_com"))
        ->delete();
    }

     return response()->json([
                'respuesta' => $respuesta,
    ]);
});

Route::get('/editar-comentario', function () {
    header("Access-Control-Allow-Origin: *");
    $value = request()->get("bd");
    $tipo = request()->get("tipo");
	$data = request()->all();

    if($tipo == "proyecto"){
        $respuesta = DB::connection("mysql")->table($value.".comentarios_proyectos")
        ->where("id",request()->get("id_com"))
        ->update(['comentario' => request()->get("comentario")]); 
    }else{
        $respuesta = DB::connection("mysql")->table($value.".comentarios")
        ->where("id",request()->get("id_com"))
        ->update(['comentario' => request()->get("comentario")]); 
    }

    return response()->json([
        'respuesta' => $respuesta,
    ]);
});