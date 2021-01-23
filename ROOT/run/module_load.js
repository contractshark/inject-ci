/**
 * Programmatic npm module loader. This interface is no longer documented in npm, so use at your own risk.
 */
"use strict";

const
	npm = require( 'npm' ),
	_npm = fn => arg => new Promise( ( res, rej ) => fn( arg, res, rej ) ),
	std = ( res, rej ) => ( err, data ) => err ? rej( err ) : res( data ),
	_install = ( name, res, rej ) => npm.commands.install( [ name ], std( res, rej ) ),
	_load = ( conf, res, rej ) => npm.load( conf, std( res, rej ) ),
	install = _npm( _install ),
	load = _npm( _load );

function load_modules( moduleNames, config )
{
	return load( config ).then( () => Promise.all( moduleNames.map( install ) ) );
}

// Alternative using a shell

const exec = require( 'child_process' ).exec;
	
function module_loader( moduleNames, registry )
{
	return new Promise( ( res, rej ) => 
		exec( 
			'npm i' + ( registry ? ' --registry=' + registry : '' ) + ' ' + moduleNames.join( ' ' ), 
			{ shell: true }, 
			( err, stdout, stderr ) => err ? rej( stderr ) : res( stdout ) 
		) 
	);
}
