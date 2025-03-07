//WaterManager是用来处理水体网格变形的，通过更新每个顶点的位置来模拟水面波浪效果
//?	代码中的 Update 方法每帧都会被调用，用于更新网格的顶点位置。
//?	通过 WaveManager 的 GetWaveHeight 方法获取每个顶点的新高度，并更新顶点数组。
//?	更新后重新设置 mesh.vertices 并重新计算法线以确保光照正确。

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]

public class WaterManager : MonoBehaviour
{
    private MeshFilter meshFilter;

    //Awake方法是Unity生命周期的一部分，在游戏对象被启用时调用。此方法在场景加载时最先被调用。
    //GetComponent<MeshFilter>()：获取当前GameObject上的MeshFilter组件并赋值给meshFilter变量

    private void Awake()//优先调用
    {
        meshFilter = GetComponent<MeshFilter>();
    }

    private void Update()
    {
        Vector3[] vertices = meshFilter.mesh.vertices; //获取当前网格的顶点数组
        for (int i = 0; i < vertices.Length; i++)
        {
            vertices[i].y = WaveManager.instance.GetWaveHeight(transform.position.x + vertices[i].x, transform.position.z + vertices[i].z);
        }
        meshFilter.mesh.vertices = vertices;
        meshFilter.mesh.RecalculateNormals();




        //循环遍历每个顶点：使用一个for循环遍历所有顶点。
        //更新y坐标：
        //使用假设存在的WaveManager实例中的GetWaveHeight方法计算新的y值。这个方法接受两个参数：
        //transform.position.x + vertices[i].x：将当前顶点的x坐标与对象的x位置相加，计算出完整的世界坐标x。
        //transform.position.z + vertices[i].z：计算出完整的世界坐标z。
        //GetWaveHeight返回特定位置的波的高度，这个值将设置为当前顶点的新y坐标。
        //更新网格数据:

    }
}