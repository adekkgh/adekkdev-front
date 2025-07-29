import { readFile } from 'fs/promises';
import { resolve } from 'path';
import { error } from '@sveltejs/kit';

export async function GET() {
    try {
        const filePath = resolve('static/tmp/.well-known/apple-developer-merchantid-domain-association');
        const file = await readFile(filePath);

        console.log(filePath);
        return new Response(file, {
            headers: {
                'Content-Type': 'application/octet-stream',
                'Content-Disposition': 'attachment; filename="apple-developer-merchantid-domain-association"'
            }
        });
    } catch (err) {
        throw error(404, 'File not found');
    }
}
