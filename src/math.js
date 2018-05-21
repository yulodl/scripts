/**
 * @author xiaodongyu
 * @date 2018/5/21-上午11:54
 * @file math.js
 */

const dotReg = /\./;

const add = (arg1, arg2) => {
    if (isNaN(arg1) || isNaN(arg2)) return '';

    arg1 = `${arg1}`;
    arg2 = `${arg2}`;
    let decimalCount1 = 0;
    let decimalCount2 = 0;
    if (dotReg.test(arg1)) {
        decimalCount1 = arg1.split(dotReg)[1].length;
    }
    if (dotReg.test(arg2)) {
        decimalCount2 = arg2.split(dotReg)[1].length;
    }
    const multiplyTimes = 10 ** Math.max(decimalCount1, decimalCount2);

    return ((arg1 * multiplyTimes) + (arg2 * multiplyTimes)) / multiplyTimes;
};

const sub = (arg1, arg2) => add(arg1, -arg2);

const mul = (arg1, arg2) => {
    if (isNaN(arg1) || isNaN(arg2)) return '';

    arg1 = `${arg1}`;
    arg2 = `${arg2}`;
    let decimalCount1 = 0;
    let decimalCount2 = 0;
    if (dotReg.test(arg1)) {
        decimalCount1 = arg1.split(dotReg)[1].length;
    }
    if (dotReg.test(arg2)) {
        decimalCount2 = arg2.split(dotReg)[1].length;
    }
    const totalTimes = 10 ** (decimalCount1 + decimalCount2);

    return ((arg1 * (10 ** decimalCount1)) * (arg2 * (10 ** decimalCount2))) / totalTimes;
};

const div = (arg1, arg2) => mul(arg1, 1 / arg2);

Object.assign(Number.prototype, {
    add(arg2) {return add(this, arg2);},
    sub(arg2) {return sub(this, arg2);},
    mul(arg2) {return mul(this, arg2);},
    div(arg2) {return div(this, arg2);}
});

export default {add, sub, mul, div};
