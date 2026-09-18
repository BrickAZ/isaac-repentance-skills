"""Compile runnable Lua fences without executing them."""
import argparse, re, subprocess
from pathlib import Path
def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--lua", required=True)
    args=parser.parse_args()
    root=Path(__file__).resolve().parents[1]
    count=0
    failures=[]
    fence=chr(96)*3
    pattern=r"^"+fence+r"lua[ \t]*\n(.*?)^"+fence+r"[ \t]*$"
    for skill in sorted((root/"skills").glob("isaac-repentogon-*")):
        for path in sorted(skill.rglob("*.md")):
            text=path.read_text(encoding="utf-8-sig")
            for match in re.finditer(pattern,text,re.M|re.S):
                count+=1
                line=text.count("\n",0,match.start())+1
                result=subprocess.run(
                    [args.lua,"-e","local s=io.read('*a'); local f,e=load(s); if not f then io.stderr:write(e); os.exit(1) end"],
                    input=match.group(1),text=True,encoding="utf-8",capture_output=True)
                if result.returncode:
                    failures.append(f"{path.relative_to(root)}:{line}: {result.stderr.strip()}")
    if not count: raise SystemExit("No Lua examples found")
    if failures: raise SystemExit("\n".join(failures))
    print(f"REPENTOGON Lua example syntax passed: {count} blocks; no engine calls executed")
if __name__=="__main__":main()

