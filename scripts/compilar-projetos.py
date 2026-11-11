"""Compila os projetos individuais usando o SDK de simulador, sem assinatura."""
from pathlib import Path
import json, os, subprocess

ROOT=Path(__file__).resolve().parents[1]
env=dict(os.environ,DEVELOPER_DIR='/Applications/Xcode.app/Contents/Developer')
resultados=[]
for app in json.loads((ROOT/'atividades.json').read_text()):
    project=next((ROOT/'apps'/app['repo']).glob('*.xcodeproj'))
    log=ROOT/'verificacao'/f"{app['repo']}-build.log"
    log.parent.mkdir(exist_ok=True)
    cmd=['xcodebuild','-project',str(project),'-scheme',project.stem,'-sdk','iphonesimulator','-destination','generic/platform=iOS Simulator','-derivedDataPath',str(ROOT/'.verificacao-individuais'),'CODE_SIGNING_ALLOWED=NO','build']
    with log.open('w') as out:
        p=subprocess.run(cmd,env=env,stdout=out,stderr=subprocess.STDOUT)
    resultado={'projeto':app['repo'],'sucesso':p.returncode==0}
    resultados.append(resultado)
    print(f"{app['repo']}: {'APROVADO' if p.returncode==0 else 'FALHOU'}",flush=True)
    if p.returncode:
        print('\n'.join(line for line in log.read_text().splitlines() if 'error:' in line),flush=True)
(ROOT/'verificacao/compilacoes.json').write_text(json.dumps(resultados,indent=2)+'\n')
raise SystemExit(0 if all(r['sucesso'] for r in resultados) else 1)
