#!/bin/bash
cd "$(dirname "$0")"

path_code="code"
path_test="Test"
CC="gcc"

# Week11_ans/Test 기대 파일은 UTF-16 LE(BOM)인 경우가 많음. 프로그램 출력(UTF-8/LF)과
# 줄바꿈(CRLF/LF) 차이를 무시하고 내용만 비교한다.
compare_outputs() {
    local actual="$1"
    local expected="$2"
    local tmp1 tmp2
    tmp1=$(mktemp)
    tmp2=$(mktemp)

    tr -d '\r' < "$actual" | sed '1s/^\xEF\xBB\xBF//' > "$tmp1"

    local sig
    sig=$(head -c 2 "$expected" 2>/dev/null | xxd -p 2>/dev/null || true)
    if [ "$sig" = "fffe" ]; then
        if ! iconv -f UTF-16LE -t UTF-8 "$expected" 2>/dev/null | tr -d '\r' | sed '1s/^\xEF\xBB\xBF//' > "$tmp2"; then
            rm -f "$tmp1" "$tmp2"
            return 1
        fi
    else
        tr -d '\r' < "$expected" | sed '1s/^\xEF\xBB\xBF//' > "$tmp2"
    fi

    if diff -q "$tmp1" "$tmp2" >/dev/null 2>&1; then
        rm -f "$tmp1" "$tmp2"
        return 0
    fi
    rm -f "$tmp1" "$tmp2"
    return 1
}

run_case() {
    local name=$1
    local suf=$2
    local outfile infile label actual

    if [ -z "$suf" ]; then
        outfile="$path_test/${name}-out.txt"
        infile="$path_test/${name}-in.txt"
        label="${name}-out.txt"
        actual="$path_test/actual-${name}.txt"
    else
        outfile="$path_test/${name}-out${suf}.txt"
        infile="$path_test/${name}-in${suf}.txt"
        label="${name}-out${suf}.txt"
        actual="$path_test/actual-${name}-${suf}.txt"
    fi

    if [ -f "$infile" ]; then
        "./$path_code/$name" < "$infile" > "$actual"
    else
        "./$path_code/$name" > "$actual"
    fi

    if compare_outputs "$actual" "$outfile"; then
        echo "$label: PASS"
    else
        echo "$label: FAIL"
    fi
    rm -f "$actual"
}

shopt -s nullglob
c_files=("$path_code"/*.c)
shopt -u nullglob

if [ ${#c_files[@]} -eq 0 ]; then
    echo "No .c files in $path_code"
    exit 1
fi

IFS=$'\n' sorted=($(printf '%s\n' "${c_files[@]}" | sort))
unset IFS

for f in "${sorted[@]}"; do
    name=$(basename "$f" .c)
    outbin="$path_code/$name"

    $CC "$f" -o "$outbin" 2>/dev/null
    if [ ! -f "$outbin" ] || [ ! -x "$outbin" ]; then
        echo "$name: COMPILE FAIL"
        continue
    fi

    if [ -f "$path_test/${name}-out.txt" ]; then
        run_case "$name" ""
    elif [ -f "$path_test/${name}-out0.txt" ]; then
        n=0
        while [ -f "$path_test/${name}-out${n}.txt" ]; do
            run_case "$name" "$n"
            n=$((n + 1))
        done
    else
        echo "$name: SKIP (no ${name}-out.txt in Test)"
    fi
done
