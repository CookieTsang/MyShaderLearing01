//WaveManager管理一个波动效果，这个效果实质上不可见
//计算水面波浪高度，提供波浪数据

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveManager : MonoBehaviour
{
    public static WaveManager instance;
    public float amplitude = 1f;//振幅，海面波幅
    public float length = 2f;//波长
    public float wide = 2f;//宽度
    public float speed = 1f;//波速
    public float offset = 0f;//偏移量(实时变化)

    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else if (instance != this)
        {
            Debug.Log("实例已经存在");
        }
    }

    private void Update()
    {
        offset += Time.deltaTime * speed;//更新偏移

    }
    public float GetWaveHeight(float _x, float _z)
    {
        return amplitude * Mathf.Sin(_x / length + offset) * Mathf.Sin(_z / wide + offset);
        //计算基于 _x 和 _z 坐标的波动值，这个波动值会随着位置的不同而变化
        //通过调整 amplitude, length, wide, offset 来改变波的形状和位置
    }
 

}

//?	public:定义了几个公开的浮点型变量，用于在 Unity 编辑器中设置波浪的属性如振幅 (amplitude)、波长 (length)、宽度 (wide)、速度 (speed) 和偏移量 (offset)。
//?	更新偏移量：在 Update 方法中，根据时间增量 (Time.deltaTime) 和设定的速度 (speed) 更新波动的偏移量 (offset)。
//?	计算波动高度：GetWaveHight 方法接收两个参数 _x 和 _z，代表空间中的坐标值。该方法返回对应位置上的波动高度。
//?	波动高度通过 amplitude 放大后的正弦和余弦函数组合计算得出，其中正弦函数依赖于 _x 坐标和 length，余弦函数依赖于 _z 坐标和 wide，两者都加上了 offset 来模拟波动随时间的变化。
//? 总结：生成一个基于时间和空间坐标的波动效果，可以应用于水面波动或其他类似场景中