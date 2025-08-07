
## Init project
```bash
mkdir -p api && cd api
pnpm init
pnpm --package=typescript dlx tsc --init
pnpm add -D @types/node tsx typescript @types/express
pnpm add typescript @types/node dotenv ts-node zod express
```

## Folder structure
```bash
mkdir -p src/{__tests__/{controllers,models,routes},controllers,models,routes/v1,services,types,utils} && touch tsconfig.json
```

## Basic files
```bash
 touch src/{app,env,index}.ts src/types/index.d.ts src/routes/v1/health.route.ts src/controllers/system.controller.ts
```


## Testing

```bash
curl -N -H "Content-Type: application/json" \
  -X POST http://localhost:4000/v1/chat \
  -d '{
    "model": "o4-mini",
    "input": "what is the weather like in Coyhaique, Chile today?"
  }'
```

```bash
curl -N -H "Content-Type: application/json" \
  -X POST http://localhost:4000/v1/chat \
  -d '{
    "model": "o4-mini",
    "input": "what are things I should do in Coyhaique, Chile. explain briefly? short and simple"
  }'
```