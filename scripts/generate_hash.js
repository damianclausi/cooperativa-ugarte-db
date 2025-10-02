#!/usr/bin/env node
const bcrypt = require('bcrypt');

async function generateHash() {
    const password = 'password123';
    const rounds = 10;
    
    console.log('🔐 Generando hash bcrypt para:', password);
    console.log('Rounds:', rounds);
    console.log('---');
    
    const hash = await bcrypt.hash(password, rounds);
    
    console.log('✅ Hash generado:');
    console.log(hash);
    console.log('---');
    console.log('📋 Copia este hash y reemplaza la línea en 05-autenticacion.sql:');
    console.log(`v_password_hash TEXT := '${hash}';`);
}

generateHash().catch(console.error);